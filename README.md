# Azure Test Environment

## Prerequisite


Before doing `vagrant up`, you can uncomment `config.vm.provision "shell", path: "bootstrap.sh"` from `.\bootstrap.sh` to automatically install DNF and Azure CLI. If you want to install it manually one by one, please follow the steps below:


### Install DNF

```
sudo yum install epel-release -y
sudo yum install dnf -y
```


### Install Azure CLI

https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-linux?pivots=dnf

Then login your azure account:

```
az login # Sign into an azure account
az account show # See the currently signed-in account.
```


### Install Java 8

sudo yum install java-1.8.0-openjdk
sudo update-alternatives --config java
vim .bash_profile



<BR>

## Create an Azure Spring Cloud instance

1. Set the global variables:

    ```
    RESOURCE_GROUP_NAME=jmataac-springtest-rg2
    SPRING_CLOUD_NAME=jmataac-springtest-s1
    ```

2. Create resource group:
    ```
    az group create \
        -g "$RESOURCE_GROUP_NAME" \
        -l eastus
    ```

3. And then create spring cloud instance:
    ```
    az spring-cloud create \
        -g "$RESOURCE_GROUP_NAME" \
        -n "$SPRING_CLOUD_NAME" \
        --sku standard \
        --enable-java-agent
    ```

3. Set resource group and spring cloud instance by default:

    ```
    az configure --defaults group=${RESOURCE_GROUP_NAME}
    az configure --defaults spring-cloud=${SPRING_CLOUD_NAME}
    ```


## Setup Azure Config Server

1. Generate personal token in GitHub
2. Create a config server inside your azure spring cloud instance.
3. On Config Server, specify the github repo, authentication method, etc.


## Build a springboot microservice

1. Create the application

    `az spring-cloud app create --name todo-service --resource-group "$RESOURCE_GROUP_NAME" --service "$SPRING_CLOUD_NAME"`

2. Create an azure database for MySQL

    ```
    az mysql server create \
        --name ${SPRING_CLOUD_NAME}-mysql \
        --resource-group "$RESOURCE_GROUP_NAME" \
        --sku-name B_Gen5_1 \
        --storage-size 5120 \
        --admin-user "spring"
    ```

3. Create the database in that server

    ```
    az mysql db create \
        --name "todos" \
        --server-name ${SPRING_CLOUD_NAME}-mysql
    ```

4. Open firewall so azure spring cloud can access it

    ```
    az mysql server firewall-rule create \
        --name ${SPRING_CLOUD_NAME}-mysql-allow-azure-ip \
        --resource-group "$RESOURCE_GROUP_NAME" \
        --server ${SPRING_CLOUD_NAME}-mysql \
        --start-ip-address "0.0.0.0" \
        --end-ip-address "0.0.0.0"
    ```

5. Bind the MySQL database to the application

6. Create a springboot microservice

    `curl https://start.spring.io/starter.tgz -d dependencies=web,mysql,data-jpa,cloud-eureka,cloud-config-client -d baseDir=todo-service -d bootVersion=2.3.6.RELEASE -d javaVersion=1.8 | tar -xzvf -`

