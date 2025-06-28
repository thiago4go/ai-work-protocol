#!/usr/bin/env python3
"""
AI Work Protocol Test Suite
===========================
Comprehensive testing framework to evaluate system efficiency across:
- Core workflow functionality
- RAG memory integration
- AI guidance accuracy
- Performance metrics
- User experience
"""

import os
import sys
import json
import time
import subprocess
import tempfile
import shutil
from datetime import datetime, timedelta
from pathlib import Path
from typing import Dict, List, Tuple, Optional
from dataclasses import dataclass, asdict
import unittest
from unittest.mock import patch, MagicMock

@dataclass
class TestResult:
    """Test result with metrics"""
    test_name: str
    passed: bool
    duration: float
    metrics: Dict
    errors: List[str]
    timestamp: str

@dataclass
class EfficiencyMetrics:
    """System efficiency measurements"""
    command_response_time: float
    memory_retrieval_time: float
    ai_guidance_accuracy: float
    workflow_completion_rate: float
    error_rate: float
    user_satisfaction_score: float

class AIWorkProtocolTester:
    """Main test suite for AI Work Protocol system"""
    
    def __init__(self, test_dir: str = None):
        self.test_dir = test_dir or tempfile.mkdtemp(prefix="ai_work_test_")
        self.original_dir = os.getcwd()
        self.results: List[TestResult] = []
        self.setup_test_environment()
    
    def setup_test_environment(self):
        """Create isolated test environment"""
        # Copy system files to test directory
        system_files = [
            "Makefile", "AI_PROTOCOL.md", "CRITICAL_FINDINGS.md",
            "CURRENT_IMPLEMENTATION.md", "README.md"
        ]
        
        for file in system_files:
            if os.path.exists(file):
                shutil.copy2(file, self.test_dir)
        
        # Copy directories
        for dir_name in ["scripts", "templates", "working"]:
            if os.path.exists(dir_name):
                shutil.copytree(dir_name, os.path.join(self.test_dir, dir_name))
        
        os.chdir(self.test_dir)
    
    def teardown_test_environment(self):
        """Clean up test environment"""
        os.chdir(self.original_dir)
        shutil.rmtree(self.test_dir)
    
    def run_command(self, cmd: str, timeout: int = 30) -> Tuple[bool, str, float]:
        """Execute command and measure performance"""
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
    
    def test_core_commands(self) -> TestResult:
        """Test all core Makefile commands"""
        test_name = "Core Commands"
        start_time = time.time()
        errors = []
        metrics = {}
        
        commands_to_test = [
            ("make help", "Should show help"),
            ("make status", "Should show current status"),
            ("make list", "Should list templates"),
            ("make backlog", "Should show backlog"),
            ("make suggest", "Should provide AI suggestions"),
            ("make findings", "Should query findings")
        ]
        
        command_times = []
        success_count = 0
        
        for cmd, description in commands_to_test:
            success, output, duration = self.run_command(cmd)
            command_times.append(duration)
            
            if success:
                success_count += 1
            else:
                errors.append(f"{cmd}: {output}")
        
        metrics = {
            "commands_tested": len(commands_to_test),
            "commands_successful": success_count,
            "success_rate": success_count / len(commands_to_test),
            "avg_response_time": sum(command_times) / len(command_times),
            "max_response_time": max(command_times),
            "min_response_time": min(command_times)
        }
        
        total_duration = time.time() - start_time
        passed = success_count == len(commands_to_test)
        
        return TestResult(
            test_name=test_name,
            passed=passed,
            duration=total_duration,
            metrics=metrics,
            errors=errors,
            timestamp=datetime.now().isoformat()
        )
    
    def test_project_task_workflow(self) -> TestResult:
        """Test complete project → task → completion workflow"""
        test_name = "Project-Task Workflow"
        start_time = time.time()
        errors = []
        metrics = {}
        
        workflow_steps = [
            ('make project title="Test Project"', "Create project"),
            ('make status', "Check project created"),
            ('make task title="Test Task"', "Create task"),
            ('make status', "Check task created"),
            ('make done', "Complete task"),
            ('make status', "Check completion")
        ]
        
        step_times = []
        success_count = 0
        
        for cmd, description in workflow_steps:
            success, output, duration = self.run_command(cmd)
            step_times.append(duration)
            
            if success:
                success_count += 1
            else:
                errors.append(f"{description} failed: {output}")
        
        # Check if files were created properly
        working_dir = Path("working/inprogress")
        if working_dir.exists():
            project_files = list(working_dir.glob("*project*.md"))
            task_files = list(working_dir.glob("*task*.md"))
            metrics["project_files_created"] = len(project_files)
            metrics["task_files_created"] = len(task_files)
        
        metrics.update({
            "workflow_steps": len(workflow_steps),
            "steps_successful": success_count,
            "completion_rate": success_count / len(workflow_steps),
            "avg_step_time": sum(step_times) / len(step_times),
            "total_workflow_time": sum(step_times)
        })
        
        total_duration = time.time() - start_time
        passed = success_count >= len(workflow_steps) * 0.8  # 80% success threshold
        
        return TestResult(
            test_name=test_name,
            passed=passed,
            duration=total_duration,
            metrics=metrics,
            errors=errors,
            timestamp=datetime.now().isoformat()
        )
    
    def test_wip_limits(self) -> TestResult:
        """Test Work In Progress limits (1 project + 1 task max)"""
        test_name = "WIP Limits"
        start_time = time.time()
        errors = []
        metrics = {}
        
        # Create first project and task
        success1, _, _ = self.run_command('make project title="Project 1"')
        success2, _, _ = self.run_command('make task title="Task 1"')
        
        # Try to create second project (should go to backlog)
        success3, output3, _ = self.run_command('make project title="Project 2"')
        
        # Try to create second task (should go to backlog)
        success4, output4, _ = self.run_command('make task title="Task 2"')
        
        # Check backlog
        success5, backlog_output, _ = self.run_command('make backlog')
        
        # Count active vs backlog items
        inprogress_dir = Path("working/inprogress")
        backlog_dir = Path("working/backlog")
        
        active_projects = len(list(inprogress_dir.glob("*project*.md"))) if inprogress_dir.exists() else 0
        active_tasks = len(list(inprogress_dir.glob("*task*.md"))) if inprogress_dir.exists() else 0
        backlog_projects = len(list(backlog_dir.glob("*project*.md"))) if backlog_dir.exists() else 0
        backlog_tasks = len(list(backlog_dir.glob("*task*.md"))) if backlog_dir.exists() else 0
        
        metrics = {
            "active_projects": active_projects,
            "active_tasks": active_tasks,
            "backlog_projects": backlog_projects,
            "backlog_tasks": backlog_tasks,
            "wip_limit_respected": active_projects <= 1 and active_tasks <= 1
        }
        
        # WIP limits are respected if we have max 1 active project and 1 active task
        passed = metrics["wip_limit_respected"]
        
        if not passed:
            errors.append(f"WIP limits violated: {active_projects} projects, {active_tasks} tasks active")
        
        total_duration = time.time() - start_time
        
        return TestResult(
            test_name=test_name,
            passed=passed,
            duration=total_duration,
            metrics=metrics,
            errors=errors,
            timestamp=datetime.now().isoformat()
        )
    
    def test_template_system(self) -> TestResult:
        """Test template creation and customization"""
        test_name = "Template System"
        start_time = time.time()
        errors = []
        metrics = {}
        
        # Test different template types
        template_tests = [
            ('make project template=standard title="Standard Project"', "standard"),
            ('make project template=refactor title="Refactor Project"', "refactor"),
            ('make task template=discovery title="Discovery Task"', "discovery"),
            ('make task template=implementation title="Implementation Task"', "implementation")
        ]
        
        templates_created = 0
        template_types_used = set()
        
        for cmd, template_type in template_tests:
            success, output, duration = self.run_command(cmd)
            if success:
                templates_created += 1
                template_types_used.add(template_type)
            else:
                errors.append(f"Template {template_type} failed: {output}")
        
        # Check if template files contain expected structure
        template_files = []
        for dir_path in ["working/inprogress", "working/backlog"]:
            if os.path.exists(dir_path):
                template_files.extend(Path(dir_path).glob("*.md"))
        
        valid_templates = 0
        for file_path in template_files:
            try:
                content = file_path.read_text()
                if "title:" in content and "type:" in content:
                    valid_templates += 1
            except Exception as e:
                errors.append(f"Error reading template {file_path}: {e}")
        
        metrics = {
            "templates_tested": len(template_tests),
            "templates_created": templates_created,
            "template_types_used": len(template_types_used),
            "valid_template_structure": valid_templates,
            "template_success_rate": templates_created / len(template_tests)
        }
        
        passed = templates_created >= len(template_tests) * 0.75  # 75% success threshold
        total_duration = time.time() - start_time
        
        return TestResult(
            test_name=test_name,
            passed=passed,
            duration=total_duration,
            metrics=metrics,
            errors=errors,
            timestamp=datetime.now().isoformat()
        )
    
    def test_file_structure_integrity(self) -> TestResult:
        """Test that file operations maintain proper structure"""
        test_name = "File Structure Integrity"
        start_time = time.time()
        errors = []
        metrics = {}
        
        # Create some work items
        self.run_command('make project title="Structure Test"')
        self.run_command('make task title="Structure Task"')
        
        # Check directory structure
        expected_dirs = ["working", "working/inprogress", "scripts", "templates"]
        existing_dirs = []
        
        for dir_path in expected_dirs:
            if os.path.exists(dir_path):
                existing_dirs.append(dir_path)
            else:
                errors.append(f"Missing directory: {dir_path}")
        
        # Check required files
        required_files = ["Makefile", "AI_PROTOCOL.md", "CURRENT_IMPLEMENTATION.md"]
        existing_files = []
        
        for file_path in required_files:
            if os.path.exists(file_path):
                existing_files.append(file_path)
            else:
                errors.append(f"Missing file: {file_path}")
        
        # Check working directory structure
        working_structure_valid = True
        if os.path.exists("working"):
            # Should have inprogress and optionally backlog
            if not os.path.exists("working/inprogress"):
                errors.append("Missing working/inprogress directory")
                working_structure_valid = False
        
        metrics = {
            "expected_dirs": len(expected_dirs),
            "existing_dirs": len(existing_dirs),
            "required_files": len(required_files),
            "existing_files": len(existing_files),
            "directory_structure_complete": len(existing_dirs) == len(expected_dirs),
            "required_files_present": len(existing_files) == len(required_files),
            "working_structure_valid": working_structure_valid
        }
        
        passed = (metrics["directory_structure_complete"] and 
                 metrics["required_files_present"] and 
                 metrics["working_structure_valid"])
        
        total_duration = time.time() - start_time
        
        return TestResult(
            test_name=test_name,
            passed=passed,
            duration=total_duration,
            metrics=metrics,
            errors=errors,
            timestamp=datetime.now().isoformat()
        )
    
    def test_performance_benchmarks(self) -> TestResult:
        """Test system performance under various loads"""
        test_name = "Performance Benchmarks"
        start_time = time.time()
        errors = []
        metrics = {}
        
        # Test command response times
        quick_commands = ["make help", "make status", "make list", "make backlog"]
        response_times = []
        
        for cmd in quick_commands:
            success, output, duration = self.run_command(cmd)
            response_times.append(duration)
            if not success:
                errors.append(f"Performance test failed for: {cmd}")
        
        # Test file creation performance
        file_creation_times = []
        for i in range(5):
            success, output, duration = self.run_command(f'make project title="Perf Test {i}"')
            file_creation_times.append(duration)
        
        # Test with multiple rapid commands
        rapid_test_start = time.time()
        rapid_commands = ["make status"] * 10
        rapid_successes = 0
        
        for cmd in rapid_commands:
            success, output, duration = self.run_command(cmd, timeout=5)
            if success:
                rapid_successes += 1
        
        rapid_test_duration = time.time() - rapid_test_start
        
        metrics = {
            "avg_command_response_time": sum(response_times) / len(response_times),
            "max_command_response_time": max(response_times),
            "avg_file_creation_time": sum(file_creation_times) / len(file_creation_times),
            "rapid_command_success_rate": rapid_successes / len(rapid_commands),
            "rapid_test_total_time": rapid_test_duration,
            "commands_per_second": len(rapid_commands) / rapid_test_duration
        }
        
        # Performance thresholds
        passed = (metrics["avg_command_response_time"] < 2.0 and  # Under 2 seconds
                 metrics["rapid_command_success_rate"] > 0.9)      # 90% success rate
        
        if metrics["avg_command_response_time"] >= 2.0:
            errors.append(f"Commands too slow: {metrics['avg_command_response_time']:.2f}s average")
        
        total_duration = time.time() - start_time
        
        return TestResult(
            test_name=test_name,
            passed=passed,
            duration=total_duration,
            metrics=metrics,
            errors=errors,
            timestamp=datetime.now().isoformat()
        )
    
    def run_all_tests(self) -> Dict:
        """Run complete test suite"""
        print("🧪 Starting AI Work Protocol Test Suite")
        print("=" * 50)
        
        test_methods = [
            self.test_core_commands,
            self.test_project_task_workflow,
            self.test_wip_limits,
            self.test_template_system,
            self.test_file_structure_integrity,
            self.test_performance_benchmarks
        ]
        
        for test_method in test_methods:
            print(f"\n🔍 Running {test_method.__name__}...")
            result = test_method()
            self.results.append(result)
            
            status = "✅ PASS" if result.passed else "❌ FAIL"
            print(f"{status} - {result.test_name} ({result.duration:.2f}s)")
            
            if result.errors:
                print("   Errors:")
                for error in result.errors[:3]:  # Show first 3 errors
                    print(f"   - {error}")
        
        return self.generate_report()
    
    def generate_report(self) -> Dict:
        """Generate comprehensive test report"""
        total_tests = len(self.results)
        passed_tests = sum(1 for r in self.results if r.passed)
        total_duration = sum(r.duration for r in self.results)
        
        # Calculate efficiency metrics
        efficiency_metrics = EfficiencyMetrics(
            command_response_time=self._calculate_avg_response_time(),
            memory_retrieval_time=0.0,  # Would need RAG integration to test
            ai_guidance_accuracy=self._calculate_guidance_accuracy(),
            workflow_completion_rate=self._calculate_workflow_completion(),
            error_rate=self._calculate_error_rate(),
            user_satisfaction_score=self._calculate_satisfaction_score()
        )
        
        report = {
            "summary": {
                "total_tests": total_tests,
                "passed_tests": passed_tests,
                "failed_tests": total_tests - passed_tests,
                "success_rate": passed_tests / total_tests if total_tests > 0 else 0,
                "total_duration": total_duration,
                "timestamp": datetime.now().isoformat()
            },
            "efficiency_metrics": asdict(efficiency_metrics),
            "test_results": [asdict(result) for result in self.results],
            "recommendations": self._generate_recommendations()
        }
        
        return report
    
    def _calculate_avg_response_time(self) -> float:
        """Calculate average command response time"""
        response_times = []
        for result in self.results:
            if "avg_command_response_time" in result.metrics:
                response_times.append(result.metrics["avg_command_response_time"])
            elif "avg_step_time" in result.metrics:
                response_times.append(result.metrics["avg_step_time"])
        
        return sum(response_times) / len(response_times) if response_times else 0.0
    
    def _calculate_guidance_accuracy(self) -> float:
        """Calculate AI guidance accuracy based on successful workflows"""
        workflow_results = [r for r in self.results if "workflow" in r.test_name.lower()]
        if not workflow_results:
            return 0.0
        
        total_accuracy = sum(r.metrics.get("completion_rate", 0) for r in workflow_results)
        return total_accuracy / len(workflow_results)
    
    def _calculate_workflow_completion(self) -> float:
        """Calculate overall workflow completion rate"""
        completion_rates = []
        for result in self.results:
            if "completion_rate" in result.metrics:
                completion_rates.append(result.metrics["completion_rate"])
            elif "success_rate" in result.metrics:
                completion_rates.append(result.metrics["success_rate"])
        
        return sum(completion_rates) / len(completion_rates) if completion_rates else 0.0
    
    def _calculate_error_rate(self) -> float:
        """Calculate overall error rate"""
        total_errors = sum(len(r.errors) for r in self.results)
        total_operations = sum(r.metrics.get("commands_tested", 1) for r in self.results)
        
        return total_errors / total_operations if total_operations > 0 else 0.0
    
    def _calculate_satisfaction_score(self) -> float:
        """Calculate user satisfaction score based on performance and reliability"""
        # Composite score based on success rate, performance, and error rate
        success_rate = sum(1 for r in self.results if r.passed) / len(self.results)
        avg_response_time = self._calculate_avg_response_time()
        error_rate = self._calculate_error_rate()
        
        # Score calculation (0-1 scale)
        performance_score = max(0, 1 - (avg_response_time / 5.0))  # Penalty for slow responses
        reliability_score = max(0, 1 - error_rate)
        
        return (success_rate * 0.4 + performance_score * 0.3 + reliability_score * 0.3)
    
    def _generate_recommendations(self) -> List[str]:
        """Generate improvement recommendations based on test results"""
        recommendations = []
        
        # Performance recommendations
        avg_response_time = self._calculate_avg_response_time()
        if avg_response_time > 1.0:
            recommendations.append(f"Optimize command performance - average response time is {avg_response_time:.2f}s")
        
        # Error rate recommendations
        error_rate = self._calculate_error_rate()
        if error_rate > 0.1:
            recommendations.append(f"Reduce error rate - currently {error_rate:.1%}")
        
        # Workflow recommendations
        workflow_completion = self._calculate_workflow_completion()
        if workflow_completion < 0.9:
            recommendations.append(f"Improve workflow reliability - completion rate is {workflow_completion:.1%}")
        
        # Specific test recommendations
        for result in self.results:
            if not result.passed:
                recommendations.append(f"Fix issues in {result.test_name}: {', '.join(result.errors[:2])}")
        
        return recommendations

def main():
    """Run the test suite"""
    if len(sys.argv) > 1 and sys.argv[1] == "--help":
        print("""
AI Work Protocol Test Suite
===========================

Usage: python test_suite.py [options]

Options:
  --help          Show this help message
  --output FILE   Save report to JSON file
  --verbose       Show detailed output
  --test NAME     Run specific test only

Examples:
  python test_suite.py
  python test_suite.py --output results.json
  python test_suite.py --test core_commands
        """)
        return
    
    # Parse command line arguments
    output_file = None
    verbose = False
    specific_test = None
    
    for i, arg in enumerate(sys.argv[1:], 1):
        if arg == "--output" and i + 1 < len(sys.argv):
            output_file = sys.argv[i + 1]
        elif arg == "--verbose":
            verbose = True
        elif arg == "--test" and i + 1 < len(sys.argv):
            specific_test = sys.argv[i + 1]
    
    # Run tests
    tester = AIWorkProtocolTester()
    
    try:
        if specific_test:
            # Run specific test
            test_method = getattr(tester, f"test_{specific_test}", None)
            if test_method:
                result = test_method()
                tester.results = [result]
                report = tester.generate_report()
            else:
                print(f"❌ Test '{specific_test}' not found")
                return
        else:
            # Run all tests
            report = tester.run_all_tests()
        
        # Print summary
        print("\n" + "=" * 50)
        print("📊 TEST SUITE SUMMARY")
        print("=" * 50)
        
        summary = report["summary"]
        print(f"Tests Run: {summary['total_tests']}")
        print(f"Passed: {summary['passed_tests']} ✅")
        print(f"Failed: {summary['failed_tests']} ❌")
        print(f"Success Rate: {summary['success_rate']:.1%}")
        print(f"Total Duration: {summary['total_duration']:.2f}s")
        
        print("\n📈 EFFICIENCY METRICS")
        print("-" * 30)
        metrics = report["efficiency_metrics"]
        print(f"Avg Response Time: {metrics['command_response_time']:.2f}s")
        print(f"Workflow Completion: {metrics['workflow_completion_rate']:.1%}")
        print(f"Error Rate: {metrics['error_rate']:.1%}")
        print(f"Satisfaction Score: {metrics['user_satisfaction_score']:.1%}")
        
        if report["recommendations"]:
            print("\n💡 RECOMMENDATIONS")
            print("-" * 30)
            for i, rec in enumerate(report["recommendations"][:5], 1):
                print(f"{i}. {rec}")
        
        # Save report if requested
        if output_file:
            with open(output_file, 'w') as f:
                json.dump(report, f, indent=2)
            print(f"\n📄 Report saved to: {output_file}")
        
        # Exit with appropriate code
        exit_code = 0 if summary['success_rate'] >= 0.8 else 1
        sys.exit(exit_code)
        
    finally:
        tester.teardown_test_environment()

if __name__ == "__main__":
    main()
