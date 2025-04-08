```markdown
# Basic SSH and Audio Setup Guide

This guide covers some essential commands for managing SSH access and enabling audio playback on your system.

---

## 🔐 SSH Setup

### 1. Enable UFW (Firewall)
```bash
sudo ufw enable
```

---

### 2. Check Local IP Address
```bash
hostname -I
```

---

### 3. Connect to Remote System via SSH
```bash
ssh 192.168.1.30
```

Replace `192.168.1.30` with your target machine's IP address.

---

## 📁 File Transfer via SSH

### Copy a File from Remote SSH to Local System
```bash
scp developer@192.168.1.30:/home/developer/Downloads/extension.png /home/developer/Downloads/
```

Make sure to:
- Replace `developer` with the correct username
- Adjust the file path as needed

---

## 🔊 Audio Playback Setup

### Install `sox` for Audio Playback Support
```bash
sudo apt install sox libsox-fmt-all
```

Once installed, you can play audio files using:
```bash
play filename.mp3
```

---

> ✅ Tip: Ensure your system has sound output enabled and not muted when testing playback.
```
