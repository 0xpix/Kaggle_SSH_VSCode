# Kaggle_SSH_VSCode

```zsh
ssh-keygen -f "/home/pix/.ssh/known_hosts" -R "[127.0.0.1]:9191"
ssh kaggle
cd /kaggle/working/

```

# **Kaggle SSH Setup & Project Deployment Guide**

This guide provides step-by-step instructions for setting up SSH access to Kaggle, transferring project files, and installing dependencies.

---

## **1️⃣ Running the Kaggle Notebook**

1. **Open Kaggle** and start a new notebook.
2. **Enable internet access** in Kaggle settings.
3. **Run the following commands** in the notebook to install and start SSH:

```bash
!sudo apt update -qq
!sudo apt install -y openssh-server
!mkdir -p /kaggle/working/.ssh
!echo "YOUR_PUBLIC_KEY" >> /kaggle/working/.ssh/authorized_keys
!chmod 700 /kaggle/working/.ssh
!chmod 600 /kaggle/working/.ssh/authorized_keys
!echo "PermitRootLogin yes" | sudo tee -a /etc/ssh/sshd_config
!echo "PasswordAuthentication no" | sudo tee -a /etc/ssh/sshd_config
!echo "PubkeyAuthentication yes" | sudo tee -a /etc/ssh/sshd_config
!sudo service ssh restart
```

✅ **Now, SSH is enabled in your Kaggle instance.**

---

## **2️⃣ Setting Up Zrok for SSH Tunneling**

1. **Install Zrok** in the Kaggle notebook:

```bash
!wget -qO- https://get.zrok.io/install.sh | sh
```

2. **Enable Zrok with your token:**

```bash
!zrok enable "YOUR_ZROK_TOKEN"
```

3. **Start the SSH tunnel:**

```bash
!zrok share private --backend-mode tcpTunnel localhost:22
```

✅ **Copy the access token from Zrok output.**

---

## **3️⃣ Connecting from WSL 2 (Your Local Machine)**

### **1️⃣ Add Zrok Access Token in WSL**

```bash
zrok enable "YOUR_ZROK_TOKEN"
zrok access private YOUR_ZROK_ACCESS_TOKEN
```

### **2️⃣ SSH into Kaggle**

```bash
ssh -p 9191 -i ~/.ssh/kaggle_rsa root@127.0.0.1
```

✅ **Now you are connected to Kaggle via SSH!**

---

## **4️⃣ Copying Your Project Files to Kaggle**

### **1️⃣ Transfer Files from WSL to Kaggle**

Run this command **in your WSL terminal**:

```bash
scp -r -P 9191 -i ~/.ssh/kaggle_rsa Stanford-RNA-3D-Folding root@127.0.0.1:/kaggle/working/
```

✅ **Now your project is in `/kaggle/working/Stanford-RNA-3D-Folding`.**

### **2️⃣ Verify in Kaggle SSH**

In the Kaggle SSH session, run:

```bash
ls -lh /kaggle/working/Stanford-RNA-3D-Folding/
```

✅ **Expected Output:**

```
drwxr-xr-x  4 root root 4.0K Mar 10 18:30 Stanford-RNA-3D-Folding
```

---

## **5️⃣ Installing Requirements in Kaggle SSH**

### **1️⃣ Navigate to the Project Folder**

```bash
cd /kaggle/working/Stanford-RNA-3D-Folding
```

### **2️⃣ Install Python & Dependencies**

If Python is missing, install it:

```bash
sudo apt update && sudo apt install -y python3 python3-pip
```

Then, install dependencies:

```bash
pip install -r requirements.txt
sudo ln -s /usr/bin/python3 /usr/bin/python
pip install --upgrade pip
pip install jax jaxlib
pip install jax[cuda12_pip] -f https://storage.googleapis.com/jax-releases/jax_cuda_releases.html
pip install optax flax termcolor
sudo apt install nvidia-utils-515 -y
```

✅ **Now all dependencies are installed!**

---

## **6️⃣ Running the Training Script**

Once inside the project folder, run:

```bash
make train
```

✅ **Now your training script is running inside Kaggle via SSH!** 🚀

---

## **✅ Summary of Steps**

1️⃣ **Run the Kaggle notebook to enable SSH & install Zrok**
2️⃣ **Connect from WSL using Zrok & SSH**
3️⃣ **Transfer your project files from WSL to Kaggle**
4️⃣ **Install project dependencies in the Kaggle SSH session**
5️⃣ **Run your training script!**

🚀 **Now your full workflow is set up! Let me know if you need any tweaks.** 😊
