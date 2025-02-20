# terraform-infra

## 기본적인 구조
infra 가 module 을 호출한다.
### infra
 - Architecture 에 필요한 주요한 두메인에 대한 추상화 계층
 - 예를 들어 Network 의 경우 AWS 의 자원 구축에 필요한 각종 Network 자원 구성의 집합
### module
 - infra 가 호출한 도메인을 구현한다.
 - 예를 들어 Network 가 특정 VPC 대역을 구축할 목적 이라면 Network CIDR, VPC, Subnet 등 Network 자원들이 구축된다

## Infra Level 설명
### Network
#### vpc, subnet, tgw, routing table 등 
### Computing
#### eks, ecs, ecr 등