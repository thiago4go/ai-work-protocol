#!/usr/bin/env python3
"""
AI Work Protocol Efficiency Test Runner
=======================================
Comprehensive test orchestrator that runs all test suites and generates
a unified efficiency evaluation report.
"""

import os
import sys
import json
import time
import argparse
from datetime import datetime
from pathlib import Path
from typing import Dict, List

# Import test suites
from test_suite import AIWorkProtocolTester
from test_rag_integration import RAGIntegrationTester
from test_user_experience import UserExperienceTester

class EfficiencyTestRunner:
    """Orchestrates all test suites for comprehensive efficiency evaluation"""
    
    def __init__(self, output_dir: str = "test_results"):
        self.output_dir = Path(output_dir)
        self.output_dir.mkdir(exist_ok=True)
        self.start_time = datetime.now()
        self.results = {}
        
    def run_comprehensive_tests(self, include_rag: bool = True, include_ux: bool = True) -> Dict:
        """Run all test suites and generate comprehensive report"""
        
        print("🚀 Starting Comprehensive AI Work Protocol Efficiency Tests")
        print("=" * 70)
        print(f"Test Session: {self.start_time.isoformat()}")
        print(f"Output Directory: {self.output_dir}")
        print()
        
        # 1. Core System Tests
        print("🔧 Running Core System Tests...")
        core_tester = AIWorkProtocolTester()
        try:
            core_results = core_tester.run_all_tests()
            self.results["core_system"] = core_results
            print(f"✅ Core tests completed - {core_results['summary']['success_rate']:.1%} success rate")
        except Exception as e:
            print(f"❌ Core tests failed: {e}")
            self.results["core_system"] = {"error": str(e)}
        finally:
            core_tester.teardown_test_environment()
        
        # 2. RAG Integration Tests (if available)
        if include_rag:
            print("\n🧠 Running RAG Integration Tests...")
            rag_tester = RAGIntegrationTester()
            try:
                rag_results = rag_tester.run_all_rag_tests()
                self.results["rag_integration"] = rag_results
                if rag_results["summary"].get("rag_available", False):
                    print(f"✅ RAG tests completed - {rag_results['summary']['success_rate']:.1%} success rate")
                else:
                    print("⚠️  RAG system not available - tests skipped")
            except Exception as e:
                print(f"❌ RAG tests failed: {e}")
                self.results["rag_integration"] = {"error": str(e)}
        
        # 3. User Experience Tests
        if include_ux:
            print("\n👤 Running User Experience Tests...")
            ux_tester = UserExperienceTester()
            try:
                ux_results = ux_tester.run_all_ux_tests()
                self.results["user_experience"] = ux_results
                print(f"✅ UX tests completed - {ux_results['summary']['avg_usability_score']:.1%} usability score")
            except Exception as e:
                print(f"❌ UX tests failed: {e}")
                self.results["user_experience"] = {"error": str(e)}
        
        # 4. Generate comprehensive report
        print("\n📊 Generating Comprehensive Report...")
        comprehensive_report = self._generate_comprehensive_report()
        
        # 5. Save results
        self._save_results(comprehensive_report)
        
        return comprehensive_report
    
    def _generate_comprehensive_report(self) -> Dict:
        """Generate unified efficiency report across all test suites"""
        
        # Calculate overall metrics
        overall_metrics = self._calculate_overall_metrics()
        
        # Generate efficiency score
        efficiency_score = self._calculate_efficiency_score()
        
        # Collect all recommendations
        all_recommendations = self._collect_recommendations()
        
        # Performance analysis
        performance_analysis = self._analyze_performance()
        
        # Risk assessment
        risk_assessment = self._assess_risks()
        
        comprehensive_report = {
            "meta": {
                "test_session_id": self.start_time.strftime("%Y%m%d_%H%M%S"),
                "timestamp": self.start_time.isoformat(),
                "duration": (datetime.now() - self.start_time).total_seconds(),
                "test_suites_run": list(self.results.keys()),
                "version": "1.0.0"
            },
            "executive_summary": {
                "overall_efficiency_score": efficiency_score,
                "system_readiness": self._assess_system_readiness(),
                "critical_issues": self._identify_critical_issues(),
                "top_recommendations": all_recommendations[:3]
            },
            "detailed_metrics": overall_metrics,
            "performance_analysis": performance_analysis,
            "risk_assessment": risk_assessment,
            "test_suite_results": self.results,
            "recommendations": {
                "immediate_actions": all_recommendations[:5],
                "medium_term_improvements": all_recommendations[5:10],
                "long_term_optimizations": all_recommendations[10:]
            },
            "benchmarks": self._generate_benchmarks()
        }
        
        return comprehensive_report
    
    def _calculate_overall_metrics(self) -> Dict:
        """Calculate unified metrics across all test suites"""
        metrics = {
            "system_reliability": 0.0,
            "performance_score": 0.0,
            "usability_score": 0.0,
            "rag_effectiveness": 0.0,
            "workflow_efficiency": 0.0,
            "error_resilience": 0.0
        }
        
        # Core system metrics
        if "core_system" in self.results and "error" not in self.results["core_system"]:
            core = self.results["core_system"]
            metrics["system_reliability"] = core["summary"]["success_rate"]
            
            # Extract performance metrics
            for result in core.get("test_results", []):
                if "avg_command_response_time" in result.get("metrics", {}):
                    response_time = result["metrics"]["avg_command_response_time"]
                    metrics["performance_score"] = max(0, 1 - (response_time / 3.0))  # 3s baseline
                
                if "completion_rate" in result.get("metrics", {}):
                    metrics["workflow_efficiency"] = result["metrics"]["completion_rate"]
        
        # RAG integration metrics
        if "rag_integration" in self.results and "error" not in self.results["rag_integration"]:
            rag = self.results["rag_integration"]
            if rag["summary"].get("rag_available", False):
                metrics["rag_effectiveness"] = rag["summary"]["avg_retrieval_accuracy"]
        
        # User experience metrics
        if "user_experience" in self.results and "error" not in self.results["user_experience"]:
            ux = self.results["user_experience"]
            metrics["usability_score"] = ux["summary"]["avg_usability_score"]
            
            # Error resilience from UX error handling test
            for result in ux.get("test_results", []):
                if result["test_name"] == "Error Handling UX":
                    metrics["error_resilience"] = result["usability_score"]
        
        return metrics
    
    def _calculate_efficiency_score(self) -> float:
        """Calculate overall system efficiency score (0-100)"""
        metrics = self._calculate_overall_metrics()
        
        # Weighted efficiency calculation
        weights = {
            "system_reliability": 0.25,
            "performance_score": 0.20,
            "usability_score": 0.20,
            "workflow_efficiency": 0.15,
            "rag_effectiveness": 0.10,
            "error_resilience": 0.10
        }
        
        efficiency_score = 0.0
        total_weight = 0.0
        
        for metric, weight in weights.items():
            if metrics[metric] > 0:  # Only include metrics we have data for
                efficiency_score += metrics[metric] * weight
                total_weight += weight
        
        # Normalize by actual weights used
        if total_weight > 0:
            efficiency_score = (efficiency_score / total_weight) * 100
        
        return round(efficiency_score, 1)
    
    def _assess_system_readiness(self) -> str:
        """Assess overall system readiness for production use"""
        efficiency_score = self._calculate_efficiency_score()
        critical_issues = len(self._identify_critical_issues())
        
        if efficiency_score >= 85 and critical_issues == 0:
            return "Production Ready"
        elif efficiency_score >= 70 and critical_issues <= 2:
            return "Ready with Minor Issues"
        elif efficiency_score >= 50:
            return "Needs Improvement"
        else:
            return "Not Ready"
    
    def _identify_critical_issues(self) -> List[str]:
        """Identify critical issues that block system effectiveness"""
        critical_issues = []
        
        # Check core system issues
        if "core_system" in self.results:
            core = self.results["core_system"]
            if "error" in core:
                critical_issues.append(f"Core system failure: {core['error']}")
            elif core.get("summary", {}).get("success_rate", 0) < 0.5:
                critical_issues.append("Core system reliability below 50%")
        
        # Check performance issues
        metrics = self._calculate_overall_metrics()
        if metrics["performance_score"] < 0.3:
            critical_issues.append("Severe performance issues detected")
        
        # Check usability issues
        if metrics["usability_score"] < 0.4:
            critical_issues.append("Critical usability problems")
        
        # Check workflow efficiency
        if metrics["workflow_efficiency"] < 0.5:
            critical_issues.append("Workflow completion rate below 50%")
        
        return critical_issues
    
    def _collect_recommendations(self) -> List[str]:
        """Collect and prioritize recommendations from all test suites"""
        all_recommendations = []
        
        # Collect from each test suite
        for suite_name, results in self.results.items():
            if "error" not in results and "recommendations" in results:
                suite_recs = results["recommendations"]
                if isinstance(suite_recs, list):
                    all_recommendations.extend(suite_recs)
                elif isinstance(suite_recs, dict):
                    for category, recs in suite_recs.items():
                        if isinstance(recs, list):
                            all_recommendations.extend(recs)
        
        # Remove duplicates and prioritize
        unique_recommendations = list(dict.fromkeys(all_recommendations))
        
        # Sort by priority (critical issues first)
        priority_keywords = ["critical", "severe", "failure", "error", "performance"]
        
        def priority_score(rec):
            score = 0
            rec_lower = rec.lower()
            for keyword in priority_keywords:
                if keyword in rec_lower:
                    score += 1
            return score
        
        unique_recommendations.sort(key=priority_score, reverse=True)
        
        return unique_recommendations
    
    def _analyze_performance(self) -> Dict:
        """Analyze performance across all test suites"""
        performance_data = {
            "response_times": [],
            "throughput_metrics": {},
            "bottlenecks": [],
            "performance_trends": {}
        }
        
        # Collect performance data from core tests
        if "core_system" in self.results and "error" not in self.results["core_system"]:
            for result in self.results["core_system"].get("test_results", []):
                metrics = result.get("metrics", {})
                
                if "avg_command_response_time" in metrics:
                    performance_data["response_times"].append({
                        "test": result["test_name"],
                        "avg_time": metrics["avg_command_response_time"],
                        "max_time": metrics.get("max_command_response_time", 0)
                    })
                
                if "commands_per_second" in metrics:
                    performance_data["throughput_metrics"][result["test_name"]] = metrics["commands_per_second"]
        
        # Identify bottlenecks
        if performance_data["response_times"]:
            avg_response_time = sum(rt["avg_time"] for rt in performance_data["response_times"]) / len(performance_data["response_times"])
            
            for rt in performance_data["response_times"]:
                if rt["avg_time"] > avg_response_time * 2:
                    performance_data["bottlenecks"].append(f"{rt['test']}: {rt['avg_time']:.2f}s")
        
        return performance_data
    
    def _assess_risks(self) -> Dict:
        """Assess risks to system effectiveness"""
        risks = {
            "high_risk": [],
            "medium_risk": [],
            "low_risk": [],
            "risk_score": 0
        }
        
        metrics = self._calculate_overall_metrics()
        
        # High risk conditions
        if metrics["system_reliability"] < 0.6:
            risks["high_risk"].append("System reliability below 60%")
        
        if metrics["performance_score"] < 0.4:
            risks["high_risk"].append("Performance significantly below acceptable levels")
        
        # Medium risk conditions
        if metrics["usability_score"] < 0.7:
            risks["medium_risk"].append("Usability issues may impact adoption")
        
        if metrics["workflow_efficiency"] < 0.8:
            risks["medium_risk"].append("Workflow inefficiencies detected")
        
        # Low risk conditions
        if metrics["rag_effectiveness"] < 0.8 and metrics["rag_effectiveness"] > 0:
            risks["low_risk"].append("RAG system could be more effective")
        
        # Calculate overall risk score
        risk_score = len(risks["high_risk"]) * 3 + len(risks["medium_risk"]) * 2 + len(risks["low_risk"]) * 1
        risks["risk_score"] = min(risk_score, 10)  # Cap at 10
        
        return risks
    
    def _generate_benchmarks(self) -> Dict:
        """Generate benchmark comparisons"""
        benchmarks = {
            "industry_standards": {
                "response_time_target": "< 2.0s",
                "reliability_target": "> 95%",
                "usability_target": "> 80%",
                "workflow_efficiency_target": "> 85%"
            },
            "current_performance": {},
            "gaps": []
        }
        
        metrics = self._calculate_overall_metrics()
        
        # Current performance vs targets
        benchmarks["current_performance"] = {
            "reliability": f"{metrics['system_reliability']:.1%}",
            "usability": f"{metrics['usability_score']:.1%}",
            "workflow_efficiency": f"{metrics['workflow_efficiency']:.1%}",
            "performance": f"{metrics['performance_score']:.1%}"
        }
        
        # Identify gaps
        if metrics["system_reliability"] < 0.95:
            benchmarks["gaps"].append(f"Reliability gap: {0.95 - metrics['system_reliability']:.1%}")
        
        if metrics["usability_score"] < 0.80:
            benchmarks["gaps"].append(f"Usability gap: {0.80 - metrics['usability_score']:.1%}")
        
        if metrics["workflow_efficiency"] < 0.85:
            benchmarks["gaps"].append(f"Workflow efficiency gap: {0.85 - metrics['workflow_efficiency']:.1%}")
        
        return benchmarks
    
    def _save_results(self, comprehensive_report: Dict):
        """Save all test results and reports"""
        timestamp = self.start_time.strftime("%Y%m%d_%H%M%S")
        
        # Save comprehensive report
        report_file = self.output_dir / f"efficiency_report_{timestamp}.json"
        with open(report_file, 'w') as f:
            json.dump(comprehensive_report, f, indent=2)
        
        # Save individual test suite results
        for suite_name, results in self.results.items():
            suite_file = self.output_dir / f"{suite_name}_results_{timestamp}.json"
            with open(suite_file, 'w') as f:
                json.dump(results, f, indent=2)
        
        # Generate summary report (human-readable)
        summary_file = self.output_dir / f"efficiency_summary_{timestamp}.md"
        self._generate_markdown_summary(comprehensive_report, summary_file)
        
        print(f"\n📄 Results saved to {self.output_dir}/")
        print(f"   - Comprehensive report: {report_file.name}")
        print(f"   - Summary report: {summary_file.name}")
    
    def _generate_markdown_summary(self, report: Dict, output_file: Path):
        """Generate human-readable markdown summary"""
        with open(output_file, 'w') as f:
            f.write(f"# AI Work Protocol Efficiency Test Report\n\n")
            f.write(f"**Test Session:** {report['meta']['timestamp']}\n")
            f.write(f"**Duration:** {report['meta']['duration']:.1f} seconds\n\n")
            
            # Executive Summary
            f.write("## Executive Summary\n\n")
            summary = report['executive_summary']
            f.write(f"- **Overall Efficiency Score:** {summary['overall_efficiency_score']}/100\n")
            f.write(f"- **System Readiness:** {summary['system_readiness']}\n")
            f.write(f"- **Critical Issues:** {len(summary['critical_issues'])}\n\n")
            
            if summary['critical_issues']:
                f.write("### Critical Issues\n")
                for issue in summary['critical_issues']:
                    f.write(f"- {issue}\n")
                f.write("\n")
            
            # Detailed Metrics
            f.write("## Detailed Metrics\n\n")
            metrics = report['detailed_metrics']
            for metric, value in metrics.items():
                f.write(f"- **{metric.replace('_', ' ').title()}:** {value:.1%}\n")
            f.write("\n")
            
            # Top Recommendations
            f.write("## Top Recommendations\n\n")
            for i, rec in enumerate(summary['top_recommendations'], 1):
                f.write(f"{i}. {rec}\n")
            f.write("\n")
            
            # Risk Assessment
            f.write("## Risk Assessment\n\n")
            risks = report['risk_assessment']
            f.write(f"**Risk Score:** {risks['risk_score']}/10\n\n")
            
            if risks['high_risk']:
                f.write("### High Risk Issues\n")
                for risk in risks['high_risk']:
                    f.write(f"- {risk}\n")
                f.write("\n")
            
            # Performance Analysis
            f.write("## Performance Analysis\n\n")
            perf = report['performance_analysis']
            if perf['bottlenecks']:
                f.write("### Performance Bottlenecks\n")
                for bottleneck in perf['bottlenecks']:
                    f.write(f"- {bottleneck}\n")
                f.write("\n")

def main():
    """Main entry point for efficiency testing"""
    parser = argparse.ArgumentParser(description="AI Work Protocol Efficiency Test Suite")
    parser.add_argument("--output-dir", default="test_results", help="Output directory for results")
    parser.add_argument("--no-rag", action="store_true", help="Skip RAG integration tests")
    parser.add_argument("--no-ux", action="store_true", help="Skip user experience tests")
    parser.add_argument("--quick", action="store_true", help="Run quick tests only")
    parser.add_argument("--report-only", help="Generate report from existing results directory")
    
    args = parser.parse_args()
    
    if args.report_only:
        # Generate report from existing results
        print("📊 Generating report from existing results...")
        # Implementation for report-only mode would go here
        return
    
    # Run comprehensive tests
    runner = EfficiencyTestRunner(args.output_dir)
    
    try:
        report = runner.run_comprehensive_tests(
            include_rag=not args.no_rag,
            include_ux=not args.no_ux
        )
        
        # Print final summary
        print("\n" + "=" * 70)
        print("🎯 FINAL EFFICIENCY ASSESSMENT")
        print("=" * 70)
        
        summary = report["executive_summary"]
        print(f"Overall Efficiency Score: {summary['overall_efficiency_score']}/100")
        print(f"System Readiness: {summary['system_readiness']}")
        print(f"Critical Issues: {len(summary['critical_issues'])}")
        
        if summary['critical_issues']:
            print("\nCritical Issues:")
            for issue in summary['critical_issues']:
                print(f"  ❌ {issue}")
        
        print(f"\nTop Recommendations:")
        for i, rec in enumerate(summary['top_recommendations'], 1):
            print(f"  {i}. {rec}")
        
        # Exit with appropriate code
        if summary['overall_efficiency_score'] >= 70 and len(summary['critical_issues']) == 0:
            print("\n✅ System passes efficiency evaluation")
            sys.exit(0)
        else:
            print("\n⚠️  System needs improvement before production use")
            sys.exit(1)
            
    except KeyboardInterrupt:
        print("\n\n⚠️  Tests interrupted by user")
        sys.exit(130)
    except Exception as e:
        print(f"\n❌ Test execution failed: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()
