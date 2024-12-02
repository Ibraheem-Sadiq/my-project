FROM ubuntu:latest
ENV ANSIBLE_VERSION 2.18.0
RUN sudo apt update; \
    apt-get install -y gcc python3; \
    apt-get install -y python3-pip; \
    apt-get clean all
RUN pip3 install --upgrade pip; \
    sudo apt install software-properties-common; \
    sudo apt-add-repository ppa:ansible/ansible; \
    sudo apt update; \
    sudo apt install ansible -y; \
    pip3 install ansible

WORKDIR /ansible

ENTRYPOINT ["sleep", "infinity"]