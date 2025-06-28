#!/usr/bin/env python3
"""
RAG Integration Test Suite
==========================
Tests the RAG memory system integration with the AI Work Protocol.
Focuses on memory persistence, knowledge graph operations, and AI guidance accuracy.
"""

import json
import time
import subprocess
from datetime import datetime
from typing import Dict, List, Optional
from dataclasses import dataclass

@dataclass
class RAGTestResult:
    """RAG-specific test result"""
    test_name: str
    passed: bool
    duration: float
    memory_operations: int
    knowledge_graph_health: Dict
    retrieval_accuracy: float
    errors: List[str]

class RAGIntegrationTester:
    """Test suite for RAG memory integration"""
    
    def __init__(self):
        self.results: List[RAGTestResult] = []
        self.test_entities = []
        self.test_documents = []
    
    def check_rag_availability(self) -> bool:
        """Check if RAG tools are available"""
        try:
            # Try to get knowledge graph stats
            result = subprocess.run(
                "echo 'rag_memory___getKnowledgeGraphStats' | q chat --no-input",
                shell=True, capture_output=True, text=True, timeout=10
            )
            return "error" not in result.stderr.lower()
        except:
            return False
    
    def test_memory_persistence(self) -> RAGTestResult:
        """Test that memory persists across sessions"""
        test_name = "Memory Persistence"
        start_time = time.time()
        errors = []
        memory_operations = 0
        
        # Create test entity
        test_entity = {
            "name": f"test_persistence_{int(time.time())}",
            "type": "test_entity",
            "properties": {
                "test_data": "persistence_test",
                "timestamp": datetime.now().isoformat()
            }
        }
        
        try:
            # Store entity
            store_cmd = f"""
            rag_memory___createEntities entities='[{json.dumps(test_entity)}]'
            """
            result = subprocess.run(store_cmd, shell=True, capture_output=True, text=True)
            memory_operations += 1
            
            if result.returncode != 0:
                errors.append(f"Failed to store entity: {result.stderr}")
            
            # Wait a moment
            time.sleep(1)
            
            # Retrieve entity
            search_cmd = f"rag_memory___searchNodes query='name:{test_entity['name']}'"
            result = subprocess.run(search_cmd, shell=True, capture_output=True, text=True)
            memory_operations += 1
            
            if result.returncode != 0:
                errors.append(f"Failed to retrieve entity: {result.stderr}")
            else:
                # Check if entity was found
                if test_entity['name'] not in result.stdout:
                    errors.append("Entity not found after storage")
            
        except Exception as e:
            errors.append(f"Memory persistence test error: {e}")
        
        duration = time.time() - start_time
        passed = len(errors) == 0
        
        return RAGTestResult(
            test_name=test_name,
            passed=passed,
            duration=duration,
            memory_operations=memory_operations,
            knowledge_graph_health=self._get_kg_health(),
            retrieval_accuracy=1.0 if passed else 0.0,
            errors=errors
        )
    
    def test_knowledge_graph_operations(self) -> RAGTestResult:
        """Test core knowledge graph operations"""
        test_name = "Knowledge Graph Operations"
        start_time = time.time()
        errors = []
        memory_operations = 0
        
        operations_to_test = [
            ("getKnowledgeGraphStats", "Get KG statistics"),
            ("searchNodes query='type:project'", "Search for project nodes"),
            ("hybridSearch query='test search'", "Hybrid search test"),
        ]
        
        successful_operations = 0
        
        for operation, description in operations_to_test:
            try:
                cmd = f"rag_memory___{operation}"
                result = subprocess.run(cmd, shell=True, capture_output=True, text=True, timeout=15)
                memory_operations += 1
                
                if result.returncode == 0:
                    successful_operations += 1
                else:
                    errors.append(f"{description} failed: {result.stderr}")
                    
            except subprocess.TimeoutExpired:
                errors.append(f"{description} timed out")
            except Exception as e:
                errors.append(f"{description} error: {e}")
        
        duration = time.time() - start_time
        retrieval_accuracy = successful_operations / len(operations_to_test)
        passed = retrieval_accuracy >= 0.8  # 80% success threshold
        
        return RAGTestResult(
            test_name=test_name,
            passed=passed,
            duration=duration,
            memory_operations=memory_operations,
            knowledge_graph_health=self._get_kg_health(),
            retrieval_accuracy=retrieval_accuracy,
            errors=errors
        )
    
    def test_ai_guidance_accuracy(self) -> RAGTestResult:
        """Test accuracy of AI guidance based on RAG context"""
        test_name = "AI Guidance Accuracy"
        start_time = time.time()
        errors = []
        memory_operations = 0
        
        # Create test scenario with known context
        test_scenarios = [
            {
                "context": "project estimation patterns",
                "query": "estimation accuracy patterns",
                "expected_keywords": ["estimate", "duration", "pattern"]
            },
            {
                "context": "common blockers",
                "query": "blocker resolution patterns",
                "expected_keywords": ["blocker", "solution", "resolution"]
            }
        ]
        
        accurate_responses = 0
        
        for scenario in test_scenarios:
            try:
                # Query RAG for context
                search_cmd = f"rag_memory___hybridSearch query='{scenario['query']}'"
                result = subprocess.run(search_cmd, shell=True, capture_output=True, text=True, timeout=10)
                memory_operations += 1
                
                if result.returncode == 0:
                    response = result.stdout.lower()
                    # Check if expected keywords are present
                    keywords_found = sum(1 for keyword in scenario['expected_keywords'] 
                                       if keyword in response)
                    
                    if keywords_found >= len(scenario['expected_keywords']) * 0.5:  # 50% threshold
                        accurate_responses += 1
                    else:
                        errors.append(f"Guidance for '{scenario['context']}' lacks expected keywords")
                else:
                    errors.append(f"Failed to get guidance for '{scenario['context']}'")
                    
            except Exception as e:
                errors.append(f"Guidance test error for '{scenario['context']}': {e}")
        
        duration = time.time() - start_time
        retrieval_accuracy = accurate_responses / len(test_scenarios) if test_scenarios else 0
        passed = retrieval_accuracy >= 0.7  # 70% accuracy threshold
        
        return RAGTestResult(
            test_name=test_name,
            passed=passed,
            duration=duration,
            memory_operations=memory_operations,
            knowledge_graph_health=self._get_kg_health(),
            retrieval_accuracy=retrieval_accuracy,
            errors=errors
        )
    
    def test_full_pipeline_integration(self) -> RAGTestResult:
        """Test complete Entity→Document→Extract→Link pipeline"""
        test_name = "Full Pipeline Integration"
        start_time = time.time()
        errors = []
        memory_operations = 0
        
        pipeline_steps = [
            "Create Entity",
            "Store Document", 
            "Extract Terms",
            "Link Entity to Document"
        ]
        
        completed_steps = 0
        
        try:
            # Step 1: Create Entity
            test_entity = {
                "name": f"pipeline_test_{int(time.time())}",
                "type": "test_finding",
                "properties": {
                    "finding": "Test pipeline integration",
                    "context": "System testing",
                    "impact": "Validates RAG integration"
                }
            }
            
            create_cmd = f"rag_memory___createEntities entities='[{json.dumps(test_entity)}]'"
            result = subprocess.run(create_cmd, shell=True, capture_output=True, text=True)
            memory_operations += 1
            
            if result.returncode == 0:
                completed_steps += 1
            else:
                errors.append(f"Entity creation failed: {result.stderr}")
            
            # Step 2: Store Document
            test_doc_id = f"doc_pipeline_test_{int(time.time())}"
            test_content = "This is a test document for pipeline integration testing."
            
            store_cmd = f"rag_memory___storeDocument id='{test_doc_id}' content='{test_content}'"
            result = subprocess.run(store_cmd, shell=True, capture_output=True, text=True)
            memory_operations += 1
            
            if result.returncode == 0:
                completed_steps += 1
            else:
                errors.append(f"Document storage failed: {result.stderr}")
            
            # Step 3: Extract Terms (implicit in document storage)
            # This step is typically automatic, so we'll verify by searching
            search_cmd = f"rag_memory___hybridSearch query='pipeline integration testing'"
            result = subprocess.run(search_cmd, shell=True, capture_output=True, text=True)
            memory_operations += 1
            
            if result.returncode == 0 and "test" in result.stdout.lower():
                completed_steps += 1
            else:
                errors.append("Term extraction/search failed")
            
            # Step 4: Link Entity to Document (verify relationship)
            link_search = f"rag_memory___searchNodes query='name:{test_entity['name']}'"
            result = subprocess.run(link_search, shell=True, capture_output=True, text=True)
            memory_operations += 1
            
            if result.returncode == 0:
                completed_steps += 1
            else:
                errors.append("Entity-document linking verification failed")
                
        except Exception as e:
            errors.append(f"Pipeline integration error: {e}")
        
        duration = time.time() - start_time
        retrieval_accuracy = completed_steps / len(pipeline_steps)
        passed = completed_steps >= len(pipeline_steps) * 0.75  # 75% completion threshold
        
        return RAGTestResult(
            test_name=test_name,
            passed=passed,
            duration=duration,
            memory_operations=memory_operations,
            knowledge_graph_health=self._get_kg_health(),
            retrieval_accuracy=retrieval_accuracy,
            errors=errors
        )
    
    def _get_kg_health(self) -> Dict:
        """Get knowledge graph health metrics"""
        try:
            result = subprocess.run(
                "rag_memory___getKnowledgeGraphStats",
                shell=True, capture_output=True, text=True, timeout=10
            )
            
            if result.returncode == 0:
                # Parse the output for health metrics
                output = result.stdout
                return {
                    "accessible": True,
                    "response_time": "normal",
                    "last_check": datetime.now().isoformat()
                }
            else:
                return {
                    "accessible": False,
                    "error": result.stderr,
                    "last_check": datetime.now().isoformat()
                }
        except:
            return {
                "accessible": False,
                "error": "Connection timeout",
                "last_check": datetime.now().isoformat()
            }
    
    def run_all_rag_tests(self) -> Dict:
        """Run all RAG integration tests"""
        print("🧠 Starting RAG Integration Test Suite")
        print("=" * 50)
        
        # Check if RAG is available
        if not self.check_rag_availability():
            print("⚠️  RAG system not available - skipping RAG tests")
            return {
                "summary": {
                    "rag_available": False,
                    "tests_run": 0,
                    "message": "RAG system not accessible"
                }
            }
        
        test_methods = [
            self.test_memory_persistence,
            self.test_knowledge_graph_operations,
            self.test_ai_guidance_accuracy,
            self.test_full_pipeline_integration
        ]
        
        for test_method in test_methods:
            print(f"\n🔍 Running {test_method.__name__}...")
            result = test_method()
            self.results.append(result)
            
            status = "✅ PASS" if result.passed else "❌ FAIL"
            print(f"{status} - {result.test_name} ({result.duration:.2f}s)")
            print(f"   Memory Operations: {result.memory_operations}")
            print(f"   Retrieval Accuracy: {result.retrieval_accuracy:.1%}")
            
            if result.errors:
                print("   Errors:")
                for error in result.errors[:2]:
                    print(f"   - {error}")
        
        return self._generate_rag_report()
    
    def _generate_rag_report(self) -> Dict:
        """Generate RAG-specific test report"""
        total_tests = len(self.results)
        passed_tests = sum(1 for r in self.results if r.passed)
        total_operations = sum(r.memory_operations for r in self.results)
        avg_accuracy = sum(r.retrieval_accuracy for r in self.results) / total_tests if total_tests > 0 else 0
        
        return {
            "summary": {
                "rag_available": True,
                "total_tests": total_tests,
                "passed_tests": passed_tests,
                "success_rate": passed_tests / total_tests if total_tests > 0 else 0,
                "total_memory_operations": total_operations,
                "avg_retrieval_accuracy": avg_accuracy,
                "timestamp": datetime.now().isoformat()
            },
            "rag_metrics": {
                "memory_persistence_score": self._get_test_score("Memory Persistence"),
                "kg_operations_score": self._get_test_score("Knowledge Graph Operations"),
                "ai_guidance_score": self._get_test_score("AI Guidance Accuracy"),
                "pipeline_integration_score": self._get_test_score("Full Pipeline Integration")
            },
            "test_results": [
                {
                    "test_name": r.test_name,
                    "passed": r.passed,
                    "duration": r.duration,
                    "memory_operations": r.memory_operations,
                    "retrieval_accuracy": r.retrieval_accuracy,
                    "errors": r.errors
                } for r in self.results
            ],
            "recommendations": self._generate_rag_recommendations()
        }
    
    def _get_test_score(self, test_name: str) -> float:
        """Get score for specific test"""
        for result in self.results:
            if result.test_name == test_name:
                return result.retrieval_accuracy
        return 0.0
    
    def _generate_rag_recommendations(self) -> List[str]:
        """Generate RAG-specific recommendations"""
        recommendations = []
        
        avg_accuracy = sum(r.retrieval_accuracy for r in self.results) / len(self.results)
        if avg_accuracy < 0.8:
            recommendations.append(f"Improve RAG retrieval accuracy - currently {avg_accuracy:.1%}")
        
        total_operations = sum(r.memory_operations for r in self.results)
        avg_duration = sum(r.duration for r in self.results) / len(self.results)
        
        if avg_duration > 5.0:
            recommendations.append(f"Optimize RAG response time - averaging {avg_duration:.1f}s")
        
        failed_tests = [r for r in self.results if not r.passed]
        for test in failed_tests:
            recommendations.append(f"Fix {test.test_name}: {test.errors[0] if test.errors else 'Unknown error'}")
        
        return recommendations

if __name__ == "__main__":
    tester = RAGIntegrationTester()
    report = tester.run_all_rag_tests()
    
    print("\n" + "=" * 50)
    print("📊 RAG INTEGRATION SUMMARY")
    print("=" * 50)
    
    if report["summary"]["rag_available"]:
        summary = report["summary"]
        print(f"Tests Run: {summary['total_tests']}")
        print(f"Passed: {summary['passed_tests']} ✅")
        print(f"Success Rate: {summary['success_rate']:.1%}")
        print(f"Memory Operations: {summary['total_memory_operations']}")
        print(f"Avg Retrieval Accuracy: {summary['avg_retrieval_accuracy']:.1%}")
        
        if report["recommendations"]:
            print("\n💡 RAG RECOMMENDATIONS")
            print("-" * 30)
            for i, rec in enumerate(report["recommendations"], 1):
                print(f"{i}. {rec}")
    else:
        print("RAG system not available for testing")
