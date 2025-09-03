# Kafka Order System

Система обработки заказов с использованием Apache Kafka и Spring Boot.

## 📋 Описание

Система состоит из двух микросервисов:

1. **order-service** - принимает заказы через REST API и отправляет события в Kafka
2. **order-status-service** - обрабатывает события заказов и отправляет события статуса

## 🏗️ Архитектура

```
HTTP Request → order-service → order-topic → order-status-service → order-status-topic → order-service
```

## ⚙️ Требования

- Java 17+
- Maven 3.6+ или Gradle 8.0+
- Apache Kafka (локально или удаленно)
- Docker (для локального запуска Kafka)

## 📁 Структура проекта

```
├── common-events/           # Общие классы событий
├── order-service/           # Сервис заказов
├── order-status-service/    # Сервис статусов заказов
├── docker-compose.yml       # Docker конфигурация для Kafka
├── start-*.bat              # Скрипты запуска для Windows
├── gradlew*.bat             # Gradle Wrapper
├── mvnw*.cmd                # Maven Wrapper
└── pom.xml                  # Корневой POM
```

---

## 🚀 Быстрый запуск

### Самый простой способ

1. **Запустите систему одним кликом (автоматический выбор):**
   ```bash
   start-auto.bat
   ```

2. **Или выберите конкретный способ:**
   ```bash
   start-gradle.bat    # С Gradle (рекомендуется)
   start.bat           # С Maven Wrapper
   start-simple.bat    # Без сборки
   ```

3. **Если Gradle не работает:**
   ```bash
   download-gradle-wrapper.bat  # Скачать Gradle Wrapper
   ```

4. **Если есть ошибки с зависимостями:**
   ```bash
   clean-rebuild.bat  # Очистка и пересборка
   ```

### Что происходит при запуске

1. ✅ Запускается Kafka + Zookeeper (Docker)
2. ✅ Собирается проект (Gradle/Maven)
3. ✅ Запускается order-status-service
4. ✅ Запускается order-service (порт 8080)
5. ✅ Открывается Kafka UI (порт 8081)

---

## 🔧 Ручной запуск

### 1. Запуск Kafka

```bash
# Запуск Kafka и Zookeeper через Docker
docker-compose up -d

# Ожидание запуска Kafka
timeout /t 30 /nobreak > nul
```

### 2. Создание топиков

```bash
# Создание топика для заказов
kafka-topics.sh --create --topic order-topic --bootstrap-server localhost:9092 --partitions 1 --replication-factor 1

# Создание топика для статусов
kafka-topics.sh --create --topic order-status-topic --bootstrap-server localhost:9092 --partitions 1 --replication-factor 1
```

### 3. Сборка проекта

```bash
# Используйте Gradle Wrapper (рекомендуется)
gradlew-improved.bat clean build

# Или используйте Maven Wrapper
mvnw-improved.cmd clean install

# Или установите Maven и используйте
mvn clean install
```

### 4. Запуск сервисов

В разных терминалах:

```bash
# С Gradle (рекомендуется)
cd order-status-service
..\gradlew-improved.bat bootRun

cd order-service
..\gradlew-improved.bat bootRun

# Или с Maven
cd order-status-service
..\mvnw-improved.cmd spring-boot:run

cd order-service
..\mvnw-improved.cmd spring-boot:run
```

**Альтернативно:**
```bash
# Если у вас есть готовые JAR файлы
cd order-status-service
java -jar build\libs\order-status-service-1.0.0.jar

cd order-service
java -jar build\libs\order-service-1.0.0.jar
```

---

## 🧪 Тестирование

После запуска протестируйте систему:

```bash
test-order.bat
```

Или вручную:
```bash
curl -X POST http://localhost:8080/api/orders \
  -H "Content-Type: application/json" \
  -d "{\"product\": \"Laptop\", \"quantity\": 2}"
```

## 🔍 Мониторинг

- **order-service**: http://localhost:8080
- **Kafka UI**: http://localhost:8081
- **Логи**: смотрите в консоли каждого сервиса

## 🛑 Остановка

Нажмите любую клавишу в окне запуска для остановки всех сервисов.

---

## 📋 Доступные скрипты запуска

| Скрипт | Описание | Рекомендация |
|--------|----------|--------------|
| `start-auto.bat` | Автоматический выбор | ⭐ Лучший |
| `start-gradle.bat` | С Gradle | ⭐ Рекомендуется |
| `start.bat` | С Maven Wrapper | ✅ Хорошо |
| `start-simple.bat` | Без сборки | 🔧 Для тестирования |
| `download-gradle-wrapper.bat` | Скачать Gradle Wrapper | 🔧 Для исправления |
| `clean-rebuild.bat` | Очистка и пересборка | 🔧 Для исправления |

---

## ⚠️ Решение проблем

### Проблема 1: WARNING: A restricted method in java.lang.System has been called

**Причина:** Новые версии Java (17+) блокируют доступ к нативным методам по умолчанию.

**Решение 1: Использовать улучшенный Maven Wrapper**
```bash
mvnw-improved.cmd clean install
```

**Решение 2: Добавить параметры безопасности**
```bash
java --enable-native-access=ALL-UNNAMED -jar your-app.jar
```

**Решение 3: Использовать Gradle (рекомендуется)**
```bash
gradlew-improved.bat clean build
```

### Проблема 2: Error: Could not find or load main class org.gradle.wrapper.GradleWrapperMain

**Причина:** Файл `gradle-wrapper.jar` отсутствует или поврежден.

**Решение 1: Скачать Gradle Wrapper автоматически**
```bash
download-gradle-wrapper.bat
```

**Решение 2: Использовать улучшенный Gradle Wrapper**
```bash
gradlew-improved.bat clean build
```

**Решение 3: Использовать Maven вместо Gradle**
```bash
mvnw-improved.cmd clean install
```

### Проблема 3: java.lang.ClassNotFoundException: com.fasterxml.jackson.databind.JavaType

**Причина:** Отсутствуют зависимости Jackson для JSON десериализации Kafka сообщений.

**Решение 1: Пересобрать проект с исправленными зависимостями**
```bash
clean-rebuild.bat
```

**Решение 2: Добавить Jackson зависимости вручную**
```xml
<dependency>
    <groupId>com.fasterxml.jackson.core</groupId>
    <artifactId>jackson-databind</artifactId>
</dependency>
<dependency>
    <groupId>com.fasterxml.jackson.datatype</groupId>
    <artifactId>jackson-datatype-jsr310</artifactId>
</dependency>
```

**Решение 3: Использовать Maven вместо Gradle**
```bash
mvnw-improved.cmd clean install
```

### Проблема 4: Maven не найден

**Причина:** Команда `mvn` не распознается системой.

**Решение 1: Использовать Maven Wrapper**
```bash
mvnw.cmd clean install
```

**Решение 2: Использовать Gradle (рекомендуется)**
```bash
gradlew-improved.bat clean build
```

**Решение 3: Установить Maven вручную**
1. Скачайте Maven с https://maven.apache.org/download.cgi
2. Распакуйте в папку (например: `C:\Program Files\Apache\maven`)
3. Добавьте в PATH: `C:\Program Files\Apache\maven\bin`
4. Перезапустите командную строку

---

## 🔧 Ручное исправление Maven

Если хотите исправить Maven Wrapper вручную:

1. **Откройте** `mvnw.cmd`
2. **Найдите строку** с `java.exe`
3. **Добавьте параметры:**
   ```cmd
   --enable-native-access=ALL-UNNAMED ^
   -Dmaven.multiModuleProjectDirectory="%~dp0" ^
   ```

---

## 🎯 Рекомендуемый порядок решения проблем

1. **Попробуйте:** `start-auto.bat`
2. **Если не работает:** `start-gradle.bat`
3. **Если проблемы с Gradle:** `start.bat`
4. **В крайнем случае:** `start-simple.bat`

---

## 📞 Поддержка

Если ничего не помогает:
1. Проверьте версию Java: `java --version`
2. Убедитесь, что Docker запущен
3. Проверьте логи в консоли
4. Попробуйте перезапустить систему

---

## 📚 API

### Создание заказа

```bash
curl -X POST http://localhost:8080/api/orders \
  -H "Content-Type: application/json" \
  -d '{
    "product": "Laptop",
    "quantity": 2
  }'
```

## 📝 Логи

### order-service
- Принимает заказы через REST API
- Отправляет события в топик `order-topic`
- Слушает события статуса из топика `order-status-topic`

### order-status-service
- Слушает события заказов из топика `order-topic`
- Отправляет события статуса в топик `order-status-topic`

## ⚙️ Конфигурация

Основные настройки Kafka находятся в `application.yml` каждого сервиса:

- `bootstrap-servers`: адрес Kafka сервера
- `group-id`: идентификатор группы потребителей
- `auto-offset-reset`: стратегия сброса смещения

## 📊 Мониторинг

Логирование настроено на уровне DEBUG для пакетов:
- `com.example`
- `org.springframework.kafka`

---

## 🚀 Автоматический запуск

Используйте скрипт, который автоматически выбирает лучший способ:

```bash
start-auto.bat
```

Этот скрипт:
1. ✅ Автоматически определяет доступные инструменты сборки
2. ✅ Выбирает Gradle, если доступен
3. ✅ Использует улучшенный Maven Wrapper
4. ✅ Fallback на обычный Maven Wrapper
5. ✅ Запускает готовые JAR файлы в крайнем случае

---

## 📋 Частые проблемы

### 1. Maven не найден
```bash
# Используйте Maven Wrapper
mvnw.cmd clean install

# Или Gradle
gradlew-improved.bat clean build
```

### 2. Gradle Wrapper не работает
```bash
# Скачайте Gradle Wrapper
download-gradle-wrapper.bat

# Или используйте улучшенную версию
gradlew-improved.bat clean build
```

### 3. Jackson зависимости отсутствуют
```bash
# Пересоберите проект
clean-rebuild.bat

# Или добавьте зависимости вручную
```

### 4. Предупреждения безопасности
```bash
# Используйте улучшенный Maven Wrapper
mvnw-improved.cmd clean install
```

### 5. Проблемы с путями
```bash
# Используйте автоматический скрипт
start-auto.bat
```

### 6. Docker не запущен
- Убедитесь, что Docker Desktop запущен
- Проверьте, что порты 8080, 8081, 9092 свободны

---

## 🔄 Альтернативные скрипты

В проекте есть несколько скриптов запуска:

- `start-gradle.bat` - использует Gradle Wrapper (рекомендуется)
- `start.bat` - использует Maven Wrapper
- `start-simple.bat` - запускает готовые JAR файлы
- `test-order.bat` - тестирует API

## 📝 Примечание

Maven Wrapper автоматически скачает Maven при первом использовании, если его нет в системе.

---

## 🎯 Что оценивается

- **Настройка Producer и Consumer** для взаимодействия с Kafka
- **Умение отправить и обработать события** из Kafka
- **Интеграция микросервисов** через Kafka
- **Логирование и мониторинг** системы
