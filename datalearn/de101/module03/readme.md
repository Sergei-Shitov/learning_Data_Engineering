# Визуализация данных

С теорией ознакомился, переходим к практике

## 3.6 Разбор компонентов BI решения на примере Google Data Studio

На сколько я понимаю, здесь все максимально упрощено.

На одной странице происходит подключение к базе данных и выборка данных, которая может осуществлять как просто кликом мышкой, так  с помощью SQL запроса к бд (Авторизация и семантический слой)

!['authorization'](./img/3.6_BI_auth_and_conn.JPG)

различные шаблоны визуализации можно найти на страрнице редактирования отчета

!['visualisation_patterns'](./img/3.6_BI_groph_types.JPG)

здесь же рядом находятся фильтры

!['filters'](./img/3.6_BI_filters.JPG)

Измерения и показатели выбираются в процессе создания диаграмм

!['dimention_measures'](./img/3.6_BI_mesures.JPG)

Иерархии здесь не наблюдается - все свалено в одну кучу

!['data'](./img/3.6_BI_data.JPG)

API и интеграция языков программирования отсутствует.
В целом, учитывая доступность и простоту, вполне себе

## 3.7 Основы визуализации данных

Улучшить можно всё, ведь нет предела совершенству :)

На данном этапе я бы изменил цветовое оформление, и самое главное изменил бы сами графики в соответствие с нуждами. Т.е. мой дашборд показывает показатели, имеет фильтры, все динамически обнавляется, но какие потребности он может закрыть? Вот это, пожалуй, я бы поменял :)

## 3.8 Знакомство с Tableau Desktop

Ввиду отсутствия лицензии и ограниченным сроком возможного знакомства в 14 дней, я начал знакомство с Power BI и потом уже с Tableau.

Впечатления от Tableau космические.
После скачивания можно перейти на Getting Started, где за 8 роликов суммарной продолжительностью минут 20, знакомят с основным интерфейсом и в результате получается первый дашборд с весьма интересным функционалом.

В Power BI можно найти огромную текстовую инструкцию, и чтобы что-то сделать нужно потратить довольно много времени, что для человека который только знакомится с инструментами, сильно отталкивает.

В общем, меня очень впечатлил довольно низкий порог вхождения в Tableau, и в тоже время, очень обширный и мощный функционал.

Первый тестовый дашборд по вступительным урокам [тут](https://public.tableau.com/app/profile/sergei1337/viz/Book1_16753548577770/Dashboard1).
Постараюсь сделать что-то добротное и интересное в итоговом задании.

## 3.9 Знакомство с Tableau Server

К сожалению, опробовать сервер не получилось в виду отсутствия технических ресурсов. Позже попоробую настроить в облаке, когда появятся средства :)

## 3.10 Знакомство с Power BI

Первое впечатление производит странное. Примерно как Excel - мощный, но тяжелый и неповоротливый. Также, как для человека только знакомящегося с BI инструментами, напрягает реобходимость изучения дополнительных языков (M и DAX). Хорошо что есть возможность делать основные операции с помощью графического интерфейса

Переходим к ДЗ

### 1 преобразование в PowerQuery

Есть соблазн просто переместить необходимые значения в Excel и не мучаться, но что делать если количество ID будет не 21 а 210к и Типов которые надо разделить не 2 а 20...
В общем получилось вот по такому пути:

1. Создаём сводную таблицу

![шаг 1](./img/3.10.1.01.JPG)

вот с такими параметрами

![шаг 2](./img/3.10.1.02.JPG)

в результате получим вот такую таблицу

![шаг 3](./img/3.10.1.03.JPG)

почти то что нужно только горизонтально :)

2. Разворачиваем таблицу используя `Transpose`

![шаг 4](./img/3.10.1.04.JPG)

после этого используем певую строку как заголовки

![шаг 5](./img/3.10.1.05.JPG)

и вот уже больше похоже на то что нужно

![шаг 6](./img/3.10.1.06.JPG)

3. Добавляем индексы просто нажимая на `Index Column` и там выбираем `From 1`

![шаг 7](./img/3.10.1.07.JPG)

Готово!

### 2

Таблицу с типами категорий делать даже проще

1. Группируем по типу

![шаг 1](./img/3.10.2.01.JPG)

![шаг 2](./img/3.10.2.02.JPG)

2. Получаем такую таблицу.

![шаг 3](./img/3.10.2.03.JPG)

остается удалить лишние колонки и добавить индексы как ID

### 3

А вот здесь с наскоку не получилось. Надо копаться глубже..
За основу пробовал взять MoM % и привести формулу к своим нуждам. Но везде выдает 0.
если решу что буду работать с Power BI то буду углубляться, соответственно.

```DAX
Amount WoW% = 
IF(
 ISFILTERED('Calendar'[Date]),
 ERROR("Time intelligence quick measures can only be grouped or filtered by the Power BI-provided date hierarchy or primary date column."),
 VAR __PREV_week = CALCULATE(SUM('Fact'[Amount]), DATEADD('Calendar'[Date].[Date], -7, DAY)
    )
 RETURN
  DIVIDE(SUM('Fact'[Amount]) - __PREV_week, __PREV_week) * 100
)
```

### 4

Пересчитывать столбец `Ammount` в Power Query не стал, а вот меру сделать получилось :)

Чтобы не менять курс каждый день в ручную использовал JSON, который можно получить здесь `https://www.cbr-xml-daily.ru/daily_json.js`

Добавил источник данных JSON и преобразовал результат в таблицу, после чего добавил значение в формулу

```DAX
Euro price = CALCULATE(DIVIDE(SUM('Fact'[Amount]), LOOKUPVALUE('exchange course'[Value],'exchange course'[Name], "Valute.EUR.Value")))
```

## 3.11 Визуализация опросов

Честно говоря, не люблю выдумывать что-то из ничего, поэтому прошу пройти опрос по финальному заданию

Дашборд можно посмотреть [здесь](https://public.tableau.com/app/profile/sergei1337/viz/AirBnB_SubRent_Tool/Dashboard1)

Описание процесса создания [тут](./AirBnB-vis/readme.md)

Сам опрос [здесь](https://forms.gle/FcpZShmxbL4JzZBA7)

Ваше мнение очень важно!

## 3.12

### STAR-methodology

Попробую описать предыдущий опыт работы с данными:

Для понимания эффективности работы оборудования небходимо было регулярно получать отчеты о производительности.
Мне было необходимо еженедельно собирать необходимую информацию, приводить её к форме отчета и отправлять заинтересованным лицам.
Чтобы достичь цели с минимальными временными затратами, я автоматизировал процессы получения данных из DW и генерирование отчета средствами Python и библиотек Pandas, NumPy, SqlAlchemy.
В результате удалось сократить временные затраты на 84%.

### Вакансии

Стремлюсь попасть на американский рынок, поэтому вакансии отслеживаю в LinkedIn :-)

## 3.13 Plotly DASH

Когда наал интересоваться визуализацией данных в процессе изучения Python наткнулся на plotly. Мне понравилось что графики даже по умолчанию получаются весьма привлекательными. Немного позже еще узнал то у них есть фреймворк DASH на базе Flask, который позволяет сделать Web-приложение с визуализацией. Коротко ознакомиться и понять как это все работает можно по уроку [здесь](https://proglib.io/p/tutorial-vizualizaciya-dannyh-v-vebe-s-pomoshchyu-python-i-dash-2021-01-11). Описан процесс с импорта необходимых библиотек, до деплоя на сервере Huroku (они правда вроде прекратили предоставлять бесплатный период).

## Финальный проект

Описание этапов разработки финального проекта можно найти [здесь](./AirBnB-vis)
