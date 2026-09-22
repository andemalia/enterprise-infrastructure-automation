# enterprise-infrastructure-automation
Automated System &amp; Network Security Compliance Audit
# Enterprise Infrastructure & Security Automation Portfolio

This repository serves as a professional portfolio demonstrating advanced capabilities in **Infrastructure-as-Code (IaC)**, systems automation, configuration management, and network security engineering across hybrid corporate environments. 

The solutions hosted here are designed to eliminate configuration drift, automate repetitive systems administration tasks, and continuously enforce compliance baselines.

---

## 🛠️ Staging & Development Sandbox Architecture
To ensure enterprise safety, all code in this repository is built, modularized, and validated inside a localized hybrid data center sandbox:
* **Hypervisor Platform:** VMware Workstation Pro
* **Control Node:** Linux (RHEL/Ubuntu) orchestration server managing standard Git version control pipelines
* **Target Nodes:** Distributed clusters running virtualized instances of **Linux** and **Windows Server** operating systems over isolated NAT/Bridged virtual networks

---

## 🚀 Core Engineering Projects

### 1. Multi-Node Security Orchestration Engine (`run_security_audit.yml`)
An enterprise-grade **Ansible Playbook** engineered to manage the lifecycle of automated configuration security audits across distributed server nodes simultaneously.

* **Problems Solved:** Eradicates the manual overhead of auditing server clusters individually; securely harvests diagnostic data back to a centralized management console.
* **Automation Mechanism:** 
  * Controls secure data transmission layers over SSH (`ansible.builtin.copy`).
  * Implements dynamic execution lifecycles with elevated root privileges (`become: yes`).
  * Aggregates distributed node files securely back to a local storage array (`ansible.builtin.fetch`).
  * Maintains lean computing overhead by executing a defensive cleanup step to delete temporary binaries post-execution.

### 2. Automated Linux Core & Network Compliance Audit (`security_audit.sh`)
A highly optimized **Bash shell script** deployed to Unix-like server endpoints to actively sweep for systems vulnerability risks and review network perimeter hygiene.

* **Problems Solved:** Flags critical Identity & Access Management (IAM) oversights, identifies unhardened cryptographic protocols, and logs hidden network entry vectors.
* **Security Scans Performed:**
  * **Network Perimeter Audit:** Queries active sockets (`ss -tuln`) to identify every open listening TCP/UDP port mapping.
  * **Cryptographic Layer Verification:** Parses SSH configuration files (`/etc/ssh/sshd_config`) to ensure mandatory protocols like `PermitRootLogin` and `PasswordAuthentication` match security baselines.
  * **IAM Credential Check:** Evaluates system authentication databases (`/etc/shadow`) to flag critical security risks like null or empty password hashes.
  * **System Integrity Verification:** Searches critical OS directories (`/etc`, `/bin`, `/sbin`) to expose world-writable files that could act as privilege escalation vectors.

---

## 📋 How to Execute the Automation Pipeline

### Prerequisites
* Ansible Control Node configured with an active inventory file (e.g., `hosts`).
* Root/Sudo administrative access on target Linux endpoints.

### Step-by-Step Execution
1. Clone the automation repository onto your control machine:
   ```bash
   git clone https://github.com
   cd enterprise-infrastructure-automation
   ```
2. Execute the cluster-wide security sweep using your target host file:
   ```bash
   ansible-playbook -i hosts run_security_audit.yml
   ```
3. Review your newly harvested enterprise logs in the central tracking folder:
   ```bash
   cat ./fetched_logs/YOUR_SERVER_IP_security_report.log
   ```
