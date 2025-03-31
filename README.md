# IaC & Kubernetes

## 개요
Terraform과 Ansible을 활용하여 EKS 기반 Kubernetes 클러스터를 구성하고,  
Istio, Longhorn, LGTM 스택 등을 통해 가용성·확장성·관측성을 확보한 환경입니다.

---

## 구축 자동화 흐름

<img src="https://github.com/user-attachments/assets/e13f2643-7197-4f83-9311-94b2d73d3b77" width="800">

### 설명
1. **Terraform & Ansible 기반 자동화**  
   VPC, EC2, EKS, Node 그룹, IAM 등 인프라 생성부터  
   Kubernetes 리소스 설치까지 완전 자동화

2. **서비스 메쉬: Istio**  
   내부 트래픽 관리 및 보안을 위한 Istio 구성  
   (Ingress Gateway, Kiali 등 포함)

3. **스토리지: Longhorn**  
   분산 스토리지 Longhorn으로 고가용성 확보

4. **자동 확장: HPA + Karpenter**  
   수평 자동 확장(HPA) 및 노드 자동 프로비저닝(Karpenter) 구성

5. **관측성: LGTM + Kiali**  
   Loki, Grafana, Tempo, Mimir 기반의 모니터링 및 분산 추적  
   + Kiali를 통한 서비스 메쉬 관측성 강화

---

## 아키텍처 구성

<img src="https://github.com/user-attachments/assets/258e90b5-4db8-424e-adfb-413ece71c137" width="1200">

---

## ⚙️ 환경 정보

| 항목            | 값                 |
|-----------------|--------------------|
| **Cloud**       | AWS                |
| **Instance**    | t3.medium          |
| **OS (AMI)**    | Ubuntu 22.04       |
| **CNI**         | Flannel            |
| **Runtime**     | containerd         |
| **Kubernetes**  | v1.28              |
