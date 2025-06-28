#!/usr/bin/env python3
"""
User Experience Test Suite
==========================
Tests the user experience aspects of the AI Work Protocol system.
Focuses on usability, workflow efficiency, and user satisfaction metrics.
"""

import os
import time
import subprocess
import json
from datetime import datetime, timedelta
from typing import Dict, List, Tuple
from dataclasses import dataclass

@dataclass
class UXTestResult:
    """User experience test result"""
    test_name: str
    passed: bool
    duration: float
    usability_score: float
    efficiency_metrics: Dict
    user_friction_points: List[str]
    errors: List[str]

class UserExperienceTester:
    """Test suite for user experience evaluation"""
    
    def __init__(self):
        self.results: List[UXTestResult] = []
        self.user_actions = []
        self.friction_points = []
    
    def test_onboarding_experience(self) -> UXTestResult:
        """Test new user onboarding flow"""
        test_name = "Onboarding Experience"
        start_time = time.time()
        errors = []
        friction_points = []
        
        # Simulate new user actions
        onboarding_steps = [
            ("make help", "User seeks help", 2.0),
            ("make status", "User checks current state", 1.0),
            ("make list", "User explores templates", 1.5),
            ("cat AI_PROTOCOL.md", "User reads protocol", 3.0),
            ("make project title='My First Project'", "User creates first project", 2.0)
        ]
        
        step_times = []
        successful_steps = 0
        user_confusion_indicators = 0
        
        for cmd, description, expected_time in onboarding_steps:
            step_start = time.time()
            success, output, duration = self._run_command(cmd)
            step_times.append(duration)
            
            if success:
                successful_steps += 1
            else:
                errors.append(f"{description} failed: {output}")
                friction_points.append(f"Command failure during {description}")
            
            # Check for confusion indicators
            if duration > expected_time * 2:
                friction_points.append(f"Slow response for {description} ({duration:.1f}s)")
                user_confusion_indicators += 1
            
            # Check output clarity
            if success and len(output.strip()) < 10:
                friction_points.append(f"Minimal feedback for {description}")
        
        # Calculate usability metrics
        completion_rate = successful_steps / len(onboarding_steps)
        avg_step_time = sum(step_times) / len(step_times)
        confusion_rate = user_confusion_indicators / len(onboarding_steps)
        
        usability_score = (completion_rate * 0.5 + 
                          (1 - min(confusion_rate, 1.0)) * 0.3 + 
                          (1 - min(avg_step_time / 3.0, 1.0)) * 0.2)
        
        efficiency_metrics = {
            "completion_rate": completion_rate,
            "avg_step_time": avg_step_time,
            "confusion_rate": confusion_rate,
            "successful_steps": successful_steps,
            "total_steps": len(onboarding_steps)
        }
        
        duration = time.time() - start_time
        passed = completion_rate >= 0.8 and confusion_rate <= 0.3
        
        return UXTestResult(
            test_name=test_name,
            passed=passed,
            duration=duration,
            usability_score=usability_score,
            efficiency_metrics=efficiency_metrics,
            user_friction_points=friction_points,
            errors=errors
        )
    
    def test_workflow_efficiency(self) -> UXTestResult:
        """Test efficiency of common workflows"""
        test_name = "Workflow Efficiency"
        start_time = time.time()
        errors = []
        friction_points = []
        
        # Test common workflow patterns
        workflows = [
            {
                "name": "Quick Status Check",
                "commands": ["make status"],
                "expected_duration": 2.0,
                "frequency": "high"
            },
            {
                "name": "Create and Start Work",
                "commands": [
                    "make project title='Test Project'",
                    "make task title='Test Task'",
                    "make status"
                ],
                "expected_duration": 5.0,
                "frequency": "medium"
            },
            {
                "name": "Complete Work Cycle",
                "commands": [
                    "make project title='Complete Test'",
                    "make task title='Complete Task'",
                    "make done",
                    "make status"
                ],
                "expected_duration": 8.0,
                "frequency": "medium"
            }
        ]
        
        workflow_scores = []
        
        for workflow in workflows:
            workflow_start = time.time()
            workflow_success = True
            workflow_output = []
            
            for cmd in workflow["commands"]:
                success, output, cmd_duration = self._run_command(cmd)
                workflow_output.append(output)
                
                if not success:
                    workflow_success = False
                    errors.append(f"Workflow '{workflow['name']}' failed at: {cmd}")
            
            workflow_duration = time.time() - workflow_start
            
            # Calculate efficiency score
            time_efficiency = min(workflow["expected_duration"] / workflow_duration, 1.0)
            success_score = 1.0 if workflow_success else 0.0
            
            workflow_score = (success_score * 0.7 + time_efficiency * 0.3)
            workflow_scores.append(workflow_score)
            
            # Check for friction points
            if workflow_duration > workflow["expected_duration"] * 1.5:
                friction_points.append(f"Slow workflow: {workflow['name']} took {workflow_duration:.1f}s")
            
            if not workflow_success:
                friction_points.append(f"Failed workflow: {workflow['name']}")
        
        # Overall efficiency metrics
        avg_workflow_score = sum(workflow_scores) / len(workflow_scores)
        successful_workflows = sum(1 for score in workflow_scores if score > 0.5)
        
        efficiency_metrics = {
            "avg_workflow_score": avg_workflow_score,
            "successful_workflows": successful_workflows,
            "total_workflows": len(workflows),
            "workflow_success_rate": successful_workflows / len(workflows)
        }
        
        usability_score = avg_workflow_score
        duration = time.time() - start_time
        passed = avg_workflow_score >= 0.7
        
        return UXTestResult(
            test_name=test_name,
            passed=passed,
            duration=duration,
            usability_score=usability_score,
            efficiency_metrics=efficiency_metrics,
            user_friction_points=friction_points,
            errors=errors
        )
    
    def test_error_handling_ux(self) -> UXTestResult:
        """Test user experience during error conditions"""
        test_name = "Error Handling UX"
        start_time = time.time()
        errors = []
        friction_points = []
        
        # Test error scenarios
        error_scenarios = [
            ("make project", "Missing required parameter"),
            ("make task", "Missing required parameter"),
            ("make done", "No active task to complete"),
            ("make activate file=nonexistent.md", "File not found"),
            ("make invalid_command", "Invalid command")
        ]
        
        helpful_error_count = 0
        clear_error_messages = 0
        
        for cmd, scenario_desc in error_scenarios:
            success, output, duration = self._run_command(cmd)
            
            # Errors are expected, so we check error message quality
            if not success or "error" in output.lower() or "usage" in output.lower():
                # Check if error message is helpful
                if any(keyword in output.lower() for keyword in ["usage", "example", "help", "required"]):
                    helpful_error_count += 1
                
                # Check if error message is clear (not just technical jargon)
                if len(output.strip()) > 20 and not output.startswith("Traceback"):
                    clear_error_messages += 1
                else:
                    friction_points.append(f"Unclear error message for: {scenario_desc}")
            else:
                # Unexpected success might indicate poor validation
                friction_points.append(f"Expected error but succeeded: {scenario_desc}")
        
        # Calculate error handling quality
        total_scenarios = len(error_scenarios)
        helpfulness_score = helpful_error_count / total_scenarios
        clarity_score = clear_error_messages / total_scenarios
        
        usability_score = (helpfulness_score * 0.6 + clarity_score * 0.4)
        
        efficiency_metrics = {
            "helpful_errors": helpful_error_count,
            "clear_errors": clear_error_messages,
            "total_error_scenarios": total_scenarios,
            "helpfulness_score": helpfulness_score,
            "clarity_score": clarity_score
        }
        
        duration = time.time() - start_time
        passed = usability_score >= 0.6
        
        return UXTestResult(
            test_name=test_name,
            passed=passed,
            duration=duration,
            usability_score=usability_score,
            efficiency_metrics=efficiency_metrics,
            user_friction_points=friction_points,
            errors=errors
        )
    
    def test_discoverability(self) -> UXTestResult:
        """Test how easily users can discover features"""
        test_name = "Feature Discoverability"
        start_time = time.time()
        errors = []
        friction_points = []
        
        # Test discoverability paths
        discovery_tests = [
            {
                "entry_point": "make help",
                "features_to_find": ["project", "task", "status", "backlog"],
                "description": "Help command discoverability"
            },
            {
                "entry_point": "make",
                "features_to_find": ["help", "status"],
                "description": "Default command behavior"
            },
            {
                "entry_point": "make list",
                "features_to_find": ["template", "standard", "discovery"],
                "description": "Template discoverability"
            }
        ]
        
        discovery_scores = []
        
        for test in discovery_tests:
            success, output, duration = self._run_command(test["entry_point"])
            
            if success:
                features_found = 0
                for feature in test["features_to_find"]:
                    if feature.lower() in output.lower():
                        features_found += 1
                
                discovery_score = features_found / len(test["features_to_find"])
                discovery_scores.append(discovery_score)
                
                if discovery_score < 0.5:
                    friction_points.append(f"Poor discoverability in {test['description']}")
            else:
                errors.append(f"Discovery test failed: {test['description']}")
                discovery_scores.append(0.0)
        
        # Test documentation accessibility
        doc_files = ["README.md", "AI_PROTOCOL.md"]
        accessible_docs = 0
        
        for doc in doc_files:
            if os.path.exists(doc):
                try:
                    with open(doc, 'r') as f:
                        content = f.read()
                        if len(content) > 100:  # Has substantial content
                            accessible_docs += 1
                except:
                    friction_points.append(f"Cannot read documentation: {doc}")
        
        doc_accessibility = accessible_docs / len(doc_files)
        
        # Overall discoverability score
        avg_discovery_score = sum(discovery_scores) / len(discovery_scores) if discovery_scores else 0
        usability_score = (avg_discovery_score * 0.7 + doc_accessibility * 0.3)
        
        efficiency_metrics = {
            "avg_discovery_score": avg_discovery_score,
            "doc_accessibility": doc_accessibility,
            "discovery_tests_passed": sum(1 for score in discovery_scores if score > 0.5),
            "total_discovery_tests": len(discovery_tests)
        }
        
        duration = time.time() - start_time
        passed = usability_score >= 0.6
        
        return UXTestResult(
            test_name=test_name,
            passed=passed,
            duration=duration,
            usability_score=usability_score,
            efficiency_metrics=efficiency_metrics,
            user_friction_points=friction_points,
            errors=errors
        )
    
    def test_cognitive_load(self) -> UXTestResult:
        """Test cognitive load and mental model clarity"""
        test_name = "Cognitive Load"
        start_time = time.time()
        errors = []
        friction_points = []
        
        # Test mental model consistency
        consistency_tests = [
            {
                "concept": "Hierarchy",
                "commands": ["make project title='Test'", "make task title='Test'"],
                "expected_behavior": "Task should be under project"
            },
            {
                "concept": "WIP Limits",
                "commands": ["make project title='P1'", "make project title='P2'"],
                "expected_behavior": "Second project should go to backlog"
            },
            {
                "concept": "Status Tracking",
                "commands": ["make status", "make project title='Status Test'", "make status"],
                "expected_behavior": "Status should reflect changes"
            }
        ]
        
        consistent_behaviors = 0
        
        for test in consistency_tests:
            test_start = time.time()
            all_successful = True
            
            for cmd in test["commands"]:
                success, output, duration = self._run_command(cmd)
                if not success:
                    all_successful = False
                    break
            
            test_duration = time.time() - test_start
            
            if all_successful:
                consistent_behaviors += 1
            else:
                friction_points.append(f"Inconsistent behavior in {test['concept']}")
            
            # Check for cognitive overload indicators
            if test_duration > 10.0:  # Taking too long suggests confusion
                friction_points.append(f"High cognitive load for {test['concept']}")
        
        # Test command naming consistency
        command_clarity_score = self._assess_command_clarity()
        
        # Test feedback clarity
        feedback_clarity_score = self._assess_feedback_clarity()
        
        # Overall cognitive load score (lower is better, so we invert)
        consistency_score = consistent_behaviors / len(consistency_tests)
        usability_score = (consistency_score * 0.4 + 
                          command_clarity_score * 0.3 + 
                          feedback_clarity_score * 0.3)
        
        efficiency_metrics = {
            "consistency_score": consistency_score,
            "command_clarity_score": command_clarity_score,
            "feedback_clarity_score": feedback_clarity_score,
            "consistent_behaviors": consistent_behaviors,
            "total_consistency_tests": len(consistency_tests)
        }
        
        duration = time.time() - start_time
        passed = usability_score >= 0.7
        
        return UXTestResult(
            test_name=test_name,
            passed=passed,
            duration=duration,
            usability_score=usability_score,
            efficiency_metrics=efficiency_metrics,
            user_friction_points=friction_points,
            errors=errors
        )
    
    def _run_command(self, cmd: str, timeout: int = 10) -> Tuple[bool, str, float]:
        """Run command and return success, output, duration"""
        start_time = time.time()
        try:
            result = subprocess.run(
                cmd, shell=True, capture_output=True, text=True, timeout=timeout
            )
            duration = time.time() - start_time
            return result.returncode == 0, result.stdout + result.stderr, duration
        except subprocess.TimeoutExpired:
            duration = time.time() - start_time
            return False, f"Command timed out after {timeout}s", duration
    
    def _assess_command_clarity(self) -> float:
        """Assess clarity of command naming and structure"""
        # Check if commands follow clear patterns
        clear_commands = [
            "make help",    # Clear purpose
            "make status",  # Clear purpose
            "make project", # Clear noun-verb pattern
            "make task",    # Clear noun-verb pattern
            "make done",    # Clear action
            "make list"     # Clear action
        ]
        
        # Test each command for clarity
        clear_count = 0
        for cmd in clear_commands:
            success, output, duration = self._run_command(f"{cmd} --help")
            if success or "usage" in output.lower():
                clear_count += 1
        
        return clear_count / len(clear_commands)
    
    def _assess_feedback_clarity(self) -> float:
        """Assess clarity of system feedback"""
        feedback_tests = [
            "make status",
            "make help",
            "make list"
        ]
        
        clear_feedback_count = 0
        
        for cmd in feedback_tests:
            success, output, duration = self._run_command(cmd)
            
            if success and output.strip():
                # Check for clear, structured output
                if any(indicator in output for indicator in ["📊", "✅", "❌", "🎯", "📋"]):
                    clear_feedback_count += 1
                elif len(output.split('\n')) > 2:  # Multi-line structured output
                    clear_feedback_count += 1
        
        return clear_feedback_count / len(feedback_tests)
    
    def run_all_ux_tests(self) -> Dict:
        """Run all user experience tests"""
        print("👤 Starting User Experience Test Suite")
        print("=" * 50)
        
        test_methods = [
            self.test_onboarding_experience,
            self.test_workflow_efficiency,
            self.test_error_handling_ux,
            self.test_discoverability,
            self.test_cognitive_load
        ]
        
        for test_method in test_methods:
            print(f"\n🔍 Running {test_method.__name__}...")
            result = test_method()
            self.results.append(result)
            
            status = "✅ PASS" if result.passed else "❌ FAIL"
            print(f"{status} - {result.test_name} ({result.duration:.2f}s)")
            print(f"   Usability Score: {result.usability_score:.1%}")
            
            if result.user_friction_points:
                print("   Friction Points:")
                for friction in result.user_friction_points[:2]:
                    print(f"   - {friction}")
        
        return self._generate_ux_report()
    
    def _generate_ux_report(self) -> Dict:
        """Generate UX test report"""
        total_tests = len(self.results)
        passed_tests = sum(1 for r in self.results if r.passed)
        avg_usability = sum(r.usability_score for r in self.results) / total_tests if total_tests > 0 else 0
        
        all_friction_points = []
        for result in self.results:
            all_friction_points.extend(result.user_friction_points)
        
        return {
            "summary": {
                "total_tests": total_tests,
                "passed_tests": passed_tests,
                "success_rate": passed_tests / total_tests if total_tests > 0 else 0,
                "avg_usability_score": avg_usability,
                "total_friction_points": len(all_friction_points),
                "timestamp": datetime.now().isoformat()
            },
            "ux_metrics": {
                "onboarding_score": self._get_test_score("Onboarding Experience"),
                "workflow_efficiency_score": self._get_test_score("Workflow Efficiency"),
                "error_handling_score": self._get_test_score("Error Handling UX"),
                "discoverability_score": self._get_test_score("Feature Discoverability"),
                "cognitive_load_score": self._get_test_score("Cognitive Load")
            },
            "friction_analysis": {
                "top_friction_points": self._analyze_friction_points(all_friction_points),
                "friction_categories": self._categorize_friction_points(all_friction_points)
            },
            "test_results": [
                {
                    "test_name": r.test_name,
                    "passed": r.passed,
                    "usability_score": r.usability_score,
                    "efficiency_metrics": r.efficiency_metrics,
                    "friction_points": r.user_friction_points
                } for r in self.results
            ],
            "recommendations": self._generate_ux_recommendations()
        }
    
    def _get_test_score(self, test_name: str) -> float:
        """Get usability score for specific test"""
        for result in self.results:
            if result.test_name == test_name:
                return result.usability_score
        return 0.0
    
    def _analyze_friction_points(self, friction_points: List[str]) -> List[Dict]:
        """Analyze and rank friction points"""
        friction_counts = {}
        for point in friction_points:
            # Group similar friction points
            key = point.split(':')[0] if ':' in point else point
            friction_counts[key] = friction_counts.get(key, 0) + 1
        
        # Sort by frequency
        sorted_friction = sorted(friction_counts.items(), key=lambda x: x[1], reverse=True)
        
        return [{"friction_point": point, "frequency": count} 
                for point, count in sorted_friction[:5]]
    
    def _categorize_friction_points(self, friction_points: List[str]) -> Dict:
        """Categorize friction points by type"""
        categories = {
            "performance": 0,
            "clarity": 0,
            "workflow": 0,
            "error_handling": 0,
            "discoverability": 0
        }
        
        for point in friction_points:
            point_lower = point.lower()
            if "slow" in point_lower or "time" in point_lower:
                categories["performance"] += 1
            elif "unclear" in point_lower or "confusing" in point_lower:
                categories["clarity"] += 1
            elif "workflow" in point_lower or "failed" in point_lower:
                categories["workflow"] += 1
            elif "error" in point_lower:
                categories["error_handling"] += 1
            elif "discover" in point_lower or "find" in point_lower:
                categories["discoverability"] += 1
        
        return categories
    
    def _generate_ux_recommendations(self) -> List[str]:
        """Generate UX improvement recommendations"""
        recommendations = []
        
        avg_usability = sum(r.usability_score for r in self.results) / len(self.results)
        if avg_usability < 0.7:
            recommendations.append(f"Overall usability needs improvement - currently {avg_usability:.1%}")
        
        # Specific test recommendations
        for result in self.results:
            if not result.passed:
                recommendations.append(f"Improve {result.test_name}: {result.user_friction_points[0] if result.user_friction_points else 'Multiple issues'}")
        
        # Performance recommendations
        performance_issues = sum(1 for r in self.results 
                               for fp in r.user_friction_points 
                               if "slow" in fp.lower())
        if performance_issues > 2:
            recommendations.append("Address performance issues affecting user experience")
        
        return recommendations[:5]  # Top 5 recommendations

if __name__ == "__main__":
    tester = UserExperienceTester()
    report = tester.run_all_ux_tests()
    
    print("\n" + "=" * 50)
    print("👤 USER EXPERIENCE SUMMARY")
    print("=" * 50)
    
    summary = report["summary"]
    print(f"Tests Run: {summary['total_tests']}")
    print(f"Passed: {summary['passed_tests']} ✅")
    print(f"Success Rate: {summary['success_rate']:.1%}")
    print(f"Avg Usability Score: {summary['avg_usability_score']:.1%}")
    print(f"Friction Points: {summary['total_friction_points']}")
    
    print("\n📊 UX METRICS")
    print("-" * 30)
    metrics = report["ux_metrics"]
    for metric, score in metrics.items():
        print(f"{metric.replace('_', ' ').title()}: {score:.1%}")
    
    if report["recommendations"]:
        print("\n💡 UX RECOMMENDATIONS")
        print("-" * 30)
        for i, rec in enumerate(report["recommendations"], 1):
            print(f"{i}. {rec}")
    
    # Save detailed report
    with open("ux_test_report.json", "w") as f:
        json.dump(report, f, indent=2)
    print(f"\n📄 Detailed report saved to: ux_test_report.json")
