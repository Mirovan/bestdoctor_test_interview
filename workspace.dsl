workspace {
    model {
        internetUser = person "Интернет пользователи" "Пользователи сервисов платформы B2C"
        sellerUser = person "Продавцы услуг" "Продавцы/посредники услуг для B2B, имеющие доступ к личному кабинету продавца"
        apiUser = person "API-пользователи" "Клиенты, использующие API, встраивающие функционал платформы себе"
            
        platformContext = softwareSystem "Platform" "Платформа по продаже цифровых страховых продуктов" {
            spaContainer = container "Single-Page Application" "Предоставляет доступ к приложению через браузер" "JavaScript, React" "Web Browser"
            
            bffContainer = container "BFF service" "Осуществляет проксирование запросвом в сервисы" "Python, Django"

            clientContainer = container "Clients service" "Личный кабинет клиента" "Python, Django"
            clientDbContainer = container "Clients Database" "Хранение данных клиента" "Redis" "Database"
            
            insuranceContainer = container "Insurance service" "Сервис страховых полисов клиента" "Python, Django"
            insuranceDbContainer = container "Insurance Database" "Хранение страховых полисов клиента" "Postgres" "Database"

            subscribeContainer = container "Subscribe service" "Сервис подписок клиента" "Python, Django"
            subscribeDbContainer = container "Subscribe Database" "Хранение подписок клиента" "Postgres" "Database"

            configuratorContainer = container "Insurance configurator service" "Сервис конфигурирования страховых продуктов с помощью DSL" "Java, Groovy, Spring"
            configuratorDbContainer = container "Insurance configurator Database" "Хранение конфигураций страховых продуктов" "Postgres" "Database"

            apiGatewayContainer = container "API Gateway" "Шлюз публичных API" "Gravitee"

            # mqContainer = container "Message Queue" "Брокер сообщений" "Kafka" "MQ"
        }

        paymentContext = softwareSystem "Payment" "Платежный шлюз" "Other" {
            paymentContainer = container "Payment service" "Внещний платежный шлюз" "" "Other"
        }



        #Связи между объектами
        internetUser -> platformContext
        internetUser -> spaContainer

        sellerUser -> platformContext
        sellerUser -> spaContainer

        apiUser -> apiGatewayContainer

        apiGatewayContainer -> clientContainer
        apiGatewayContainer -> insuranceContainer
        apiGatewayContainer -> subscribeContainer
        apiGatewayContainer -> configuratorContainer
        
        spaContainer -> bffContainer "Выполняет API запросы" "JSON/HTTPS"
        
        bffContainer -> clientContainer "Выполняет API запросы" "JSON/HTTPS"
        bffContainer -> insuranceContainer "Выполняет API запросы" "JSON/HTTPS"
        bffContainer -> subscribeContainer "Выполняет API запросы" "JSON/HTTPS"

        clientContainer -> clientDbContainer
        clientContainer -> insuranceContainer
        clientContainer -> subscribeContainer
        clientContainer -> configuratorContainer
        clientContainer -> paymentContainer

        insuranceContainer -> insuranceDbContainer

        subscribeContainer -> subscribeDbContainer

        configuratorContainer -> configuratorDbContainer

        # paymentContainer -> mqContainer
        # mqContainer -> paymentContainer

    }

    views {
        systemContext platformContext "SystemContext" {
            include internetUser apiUser sellerUser paymentContext
            autoLayout lr
        }

        container platformContext {
            include *
            autolayout
        }

        styles {
            element "Software System" {
                background #1168bd
                color #ffffff
            }
            element "Person" {
                shape person
                background #08427b
                color #ffffff
            }
            element "Container" {
                background #438dd5
                color #ffffff
            }
            element "Web Browser" {
                shape WebBrowser
            }
            element "Database" {
                shape Cylinder
                background #7aa5c2
            }
            element "Component" {
                background #85bbf0
                color #000000
            }
            element "MQ" {
                background #555555
                color #000000
            }
            element "Other" {
                background #eeeeee
                color #000000
            }
        }
    }

}