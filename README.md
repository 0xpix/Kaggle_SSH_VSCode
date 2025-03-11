Start by going to this Notebook: [Kaggle_VSCode_Remote_SSH](https://www.kaggle.com/code/nschlfat/ssh-kaggle-vscode) and click on the "Copy and Edit" button to create your own copy of the notebook. Follow Step by Step instructions in the notebook.

The notebook will install the necessary packages, clone a Github repo to run
scripts to setup up the SSH connection, and the zrok tunneling service.

After you have completed the steps in the notebook and copied the private key, go to your terminal first and run these scripts:

## WSL (Windows Subsystem for Linux)

```bash
curl -sSf https://get.openziti.io/install.bash | sudo bash -s zrok
zrok enable "REPLACE_WITH_TOKEN_FROM_ZROK_ACCOUNT"
zrok access private REPLACE_WITH_PRIVATE_KEY_COPIED_FROM_NOTEBOOK
```

Open anothe tab in your terminal and run this script:

```bash
ssh-keygen -f "/home/USERNAME/.ssh/known_hosts" -R "[127.0.0.1]:9191"
```

## Windows powershell

Follow these steps to install zrok from their guide on Windows: [Zrok_Windows](https://docs.zrok.io/docs/guides/install/windows/)

```bash
zrok enable "REPLACE_WITH_TOKEN_FROM_ZROK_ACCOUNT"
zrok access private REPLACE_WITH_PRIVATE_KEY_COPIED_FROM_NOTEBOOK
```

Now go to VS Code and install the Remote - SSH extension. Press `Ctrl + Shift + P` and type `Remote-SSH: Connect to Host...` and select `Configure SSH Hosts...`. Add the following configuration:

```json
Host Kaggle
    HostName 127.0.0.1
    User root
    Port 9191
    IdentityFile C:\Users\USERNAME\.ssh\kaggle_rsa
    UserKnownHostsFile /dev/null
    StrictHostKeyChecking no
```

`Ctrl + Shift + P` again and type `Remote-SSH: Connect to Host...` and select `Kaggle`. You should now be connected to Kaggle via SSH.

Last step, you can copy files from your local machine to Kaggle by running this script in your terminal:

```bash
rsync -avz -e "ssh -p 9191 -i ~/.ssh/kaggle_rsa" ./PATH/TO/PROJECT root@127.0.0.1:/kaggle/working/PROJECT_NAME/
cd /kaggle/working/PROJECT_NAME
code .
```

We used `rsyn` for faster file transfer. You can also use scp to copy files
from your local machine to Kaggle.

That's it! You can now use Kaggle's GPUs/TPUs. Enjoy!

## Problems that I encountered

1. **Python doesn't exist.**
   - Solution: Install Python3.

```bash
sudo apt update
sudo apt install python3 python3-pip python3-venv
sudo rm /usr/bin/python
sudo ln -s /usr/bin/python3 /usr/bin/python
pip install --upgrade pip
python --version
```

2. **Nothing shows when I type `nvidia-smi`.**
   - Solution: Install NVIDIA utilities.

```bash
echo "🖥 Installing NVIDIA utilities..."
sudo apt install nvidia-utils-515 -y
```

# Sources

[Kaggle_VSCode_Remote_SSH](https://github.com/buidai123/Kaggle_VSCode_Remote_SSH/tree/main)
