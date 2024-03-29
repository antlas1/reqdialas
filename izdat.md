Порядок работы с виртуальным "издательством" Диалас:

```mermaid
sequenceDiagram
    autonumber
    Participant A as Автор-программист
    Participant I as Издатель-заказчик
    Participant T as Тестировщик
    Participant G as Общая группа
    I ->> A : ТЗ
    A ->> I : Уточнение
    I ->> A : Объем работ на релиз
    A ->> A : Программирование <br> сырой бетты
    A ->> I : Сырая бетта версия
    Note over A, G: Повтор разработки, до первого релиза бетты
    A ->> G : Ссылка на свежий релиз
    T ->> G : Отчёт о проверке
    G ->> A : Получение и анализ отчёта
    A ->> T : Уточнение замечаний (при необходимости)
    A ->> I : Уточнение ТЗ (при необходимости)
    Note over A, G: Повтор разработки и тестирования до 2х месяцев
    I ->> I : Выкладывание на сайт
    I ->> I : Сбор отзывов и замечаний
    I ->> A : Отправка отзывов, замечаний и доп пожеланий
    Note over A, G: Улучшение версии по желанию автора
```

"Диалас" отбирает идеи для ТЗ и формирует вариант, удобный для реализации начинающим программистам. 
Особенность "сырой бетты" в том, что не требуется выполнение всего ТЗ, должны быть первые шаги, которые позволят выполнить дымовое тестирование и наать полноценный бетта-тест.
