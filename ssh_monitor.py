#!/usr/bin/env python
#coding:utf-8
import sys
import paramiko


def storage():
    ssh=paramiko.SSHClient()
    ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    ##update the hostname and password
    ssh.connect(hostname="192.168.1.15",port=22,username="user",password="pass") 

    stdin,stdout,stderr=ssh.exec_command('pydf',get_pty=True)
    result = stdout.read()
    print(result.decode())
    stdin,stdout2,stderr=ssh.exec_command('sudo ls /home/user/test|wc -l',get_pty=True)
    result2 = stdout2.read()
    print('Fastq number: ',result2.decode())

if __name__ == '__main__':
    storage()
