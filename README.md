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