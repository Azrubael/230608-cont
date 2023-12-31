# Основы Kubernetes
===================
*   https://kubernetes.io/ru/docs/tutorials/kubernetes-basics/

Все руководства используют сервис Katacoda, поэтому в браузере будет показан виртуальный терминал с запущенным Minikube — небольшой локальной средой Kubernetes, которая может работать где угодно. 

Kubernetes [k8s] - платформа с открытым исходным кодом промышленного уровня, которая управляет размещением и планированием запуска контейнеров приложений в пределах кластеров (скоплений) компьютеров и между ними (кластерами).


# Использование Minikube для создания кластера
==============================================
*    https://kubernetes.io/ru/docs/tutorials/kubernetes-basics/create-cluster/cluster-intro/

Кластер Kubernetes состоит из двух типов ресурса:
    Мастер (ведущий узел) управляет кластером
    Рабочие узлы — машины, на которых выполняются приложения
Ведущие узлы (мастера) управляют кластером и узлами, которые используются для запуска приложений.
Kubelet — агент, управляющий рабочим узлом и взаимодействующий с ведущим узлом Kubernetes.

Minikube — это упрощённая реализация Kubernetes, которая создает виртуальную машину на вашем локальном компьютере и разворачивает простой кластер с одним узлом.