﻿
Функция СведенияОВнешнейОбработке() Экспорт
	
	ПараметрыРегистрации = ДополнительныеОтчетыИОбработки.СведенияОВнешнейОбработке();
	ПараметрыРегистрации.Вид = ДополнительныеОтчетыИОбработкиКлиентСервер.ВидОбработкиПечатнаяФорма();
	ПараметрыРегистрации.Версия = "1.0";
	ПараметрыРегистрации.БезопасныйРежим = Ложь;
	ПараметрыРегистрации.Назначение.Добавить("Документ.ПриемНаРаботу");
	
	Команда = ПараметрыРегистрации.Команды.Добавить();
	Команда.Представление = НСтр("ru = 'Трудовой договор (ВПФ)'");
	Команда.Идентификатор = "MXL_ПФ_ТрудовойДоговор";
	Команда.Использование = ДополнительныеОтчетыИОбработкиКлиентСервер.ТипКомандыВызовСерверногоМетода();
	Команда.ПоказыватьОповещение = Ложь;
	Команда.Модификатор = "ПечатьMXL";
	
	Возврат ПараметрыРегистрации;
	
КонецФункции

Процедура Печать(МассивОбъектов, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	ПечатнаяФорма = УправлениеПечатью.СведенияОПечатнойФорме(КоллекцияПечатныхФорм, "MXL_ПФ_ТрудовойДоговор");
	
	
	Если ПечатнаяФорма <> Неопределено Тогда
	
		ПечатнаяФорма.ТабличныйДокумент = СформироватьТрудовойДоговор(МассивОбъектов, ОбъектыПечати);
		ПечатнаяФорма.СинонимМакета = НСтр("ru='Трудовой договор (ВПФ)'");
	
	КонецЕсли; 
КонецПроцедуры

// <Описание функции>
//
// Параметры:
//  МассивОбъектов	 - 	 - 
//  ОбъектыПечати	 - 	 - 
// 
// Возвращаемое значение:
//   - <Тип.Вид>   - <описание возвращаемого значения>
//
Функция СформироватьТрудовойДоговор(МассивОбъектов, ОбъектыПечати)

	Макет = ПолучитьМакет("MXL_ПФ_ТрудовойДоговор");
	ТабДок = Новый ТабличныйДокумент;
	
	НомерСтрокиНачало = ТабДок.ВысотаСтраницы + 1;
	ТабДок.КлючПараметровПечати = "ПриемНаРаботу_ТрудовойДоговор";
	ДанныеДляПечати = ДанныеДляПечатиТрудовогоДоговора(МассивОбъектов);
	
	ПервыйПриказ = Истина;
	
	Для каждого ОписаниеПараметров Из ДанныеДляПечати Цикл
	
		МассивДанныхЗаполнения = ОписаниеПараметров.Значение;
		НомерСтрокиНачало = ТабДок.ВысотаТаблицы + 1;

		Для каждого ПараметрыМакета Из МассивДанныхЗаполнения Цикл
		
			Если Не ПервыйПриказ Тогда
				ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
			Иначе
				ПервыйПриказ = Ложь;
			КонецЕсли;
			
			ОбластьТрудовойДоговор = Макет.ПолучитьОбласть("ТрудовойДоговор");
			ОбластьТрудовойДоговор.Параметры.Заполнить(ПараметрыМакета);
			ТабДок.Вывести(ОбластьТрудовойДоговор);
			
		
		КонецЦикла; 
	    УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабДок, НомерСтрокиНачало, ОбъектыПечати, ОписаниеПараметров.Ключ);
	КонецЦикла; 
	
	
	Возврат ТабДок;

КонецФункции // СформироватьТрудовойДоговор()


Функция ДанныеДляПечатиТрудовогоДоговора(МассивОбъектов, ИмяМакета = Неопределено)
	УстановитьПривилегированныйРежим(Истина);
	ДанныеДляПечати = Новый Соответствие;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	
	Запрос.Текст =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ПриемНаРаботу.Номер КАК ПриказОПриемеНомер,
		|	ПриемНаРаботу.Дата КАК ПриказОПриемеДата,
		|	ПриемНаРаботу.Организация.НаименованиеПолное КАК ОрганизацияНаименованиеПолное,
		|	ПриемНаРаботу.Организация.НаименованиеСокращенное КАК ОрганизацияНаименованиеСокращенное,
		|	ПриемНаРаботу.Сотрудник,
		|	ПриемНаРаботу.Должность,
		|	ПриемНаРаботу.Подразделение,
		|	ПриемНаРаботу.ВидЗанятости,
		|	ПриемНаРаботу.ТрудовойДоговорНомер,
		|	ПриемНаРаботу.ТрудовойДоговорДата,
		|	ПриемНаРаботу.Руководитель,
		|	ПриемНаРаботу.ДолжностьРуководителя,
		|	ПриемНаРаботу.ДатаПриема,
		|	ПриемНаРаботу.Ссылка,
		|	ПриемНаРаботу.Организация,
		|	ПриемНаРаботу.ДатаЗавершенияТрудовогоДоговора,
		|	ПриемНаРаботу.РазрешениеНаРаботу,
		|	ПриемНаРаботу.РазрешениеНаПроживание,
		|	ПриемНаРаботу.УсловияОказанияМедпомощи,
		|	ПриемНаРаботу.ОснованиеПредставителяНанимателя,
		|	ПриемНаРаботу.ОборудованиеРабочегоМеста,
		|	ПриемНаРаботу.ИныеУсловияДоговора
		|ПОМЕСТИТЬ ВТДанныеПриказаОПриеме
		|ИЗ
		|	Документ.ПриемНаРаботу КАК ПриемНаРаботу
		|ГДЕ
		|	ПриемНаРаботу.Ссылка В(&МассивОбъектов)
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ПриемНаРаботуСпискомСотрудники.Ссылка.Номер,
		|	ПриемНаРаботуСпискомСотрудники.Ссылка.Дата,
		|	ПриемНаРаботуСпискомСотрудники.Ссылка.Организация.НаименованиеПолное,
		|	ПриемНаРаботуСпискомСотрудники.Ссылка.Организация.НаименованиеСокращенное,
		|	ПриемНаРаботуСпискомСотрудники.Сотрудник,
		|	ПриемНаРаботуСпискомСотрудники.Должность,
		|	ПриемНаРаботуСпискомСотрудники.Подразделение,
		|	ПриемНаРаботуСпискомСотрудники.ВидЗанятости,
		|	ПриемНаРаботуСпискомСотрудники.ТрудовойДоговорНомер,
		|	ПриемНаРаботуСпискомСотрудники.ТрудовойДоговорДата,
		|	ПриемНаРаботуСпискомСотрудники.Ссылка.Руководитель,
		|	ПриемНаРаботуСпискомСотрудники.Ссылка.ДолжностьРуководителя,
		|	ПриемНаРаботуСпискомСотрудники.ДатаПриема,
		|	ПриемНаРаботуСпискомСотрудники.Ссылка,
		|	ПриемНаРаботуСпискомСотрудники.Ссылка.Организация,
		|	ПриемНаРаботуСпискомСотрудники.ДатаЗавершенияТрудовогоДоговора,
		|	ПриемНаРаботуСпискомСотрудники.РазрешениеНаРаботу,
		|	ПриемНаРаботуСпискомСотрудники.РазрешениеНаПроживание,
		|	ПриемНаРаботуСпискомСотрудники.УсловияОказанияМедпомощи,
		|	ПриемНаРаботуСпискомСотрудники.Ссылка.ОснованиеПредставителяНанимателя,
		|	ПриемНаРаботуСпискомСотрудники.ОборудованиеРабочегоМеста,
		|	ПриемНаРаботуСпискомСотрудники.ИныеУсловияДоговора
		|ИЗ
		|	Документ.ПриемНаРаботуСписком.Сотрудники КАК ПриемНаРаботуСпискомСотрудники
		|ГДЕ
		|	ПриемНаРаботуСпискомСотрудники.Ссылка В(&МассивОбъектов)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
		|	ДанныеПриказаОПриеме.Сотрудник,
		|	ДанныеПриказаОПриеме.ДатаПриема КАК Период
		|ПОМЕСТИТЬ ВТСотрудникиПериоды
		|ИЗ
		|	ВТДанныеПриказаОПриеме КАК ДанныеПриказаОПриеме
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ДанныеПриказаОПриеме.Руководитель КАК ФизическоеЛицо,
		|	ДанныеПриказаОПриеме.ДатаПриема КАК Период
		|ПОМЕСТИТЬ ВТФизическиеЛицаПериоды
		|ИЗ
		|	ВТДанныеПриказаОПриеме КАК ДанныеПриказаОПриеме";
	
	Запрос.Выполнить();
	
	// Получение кадровых данных сотрудника.
	ОписательВременныхТаблиц = КадровыйУчет.ОписательВременныхТаблицДляСоздатьВТКадровыеДанныеСотрудников(
		Запрос.МенеджерВременныхТаблиц,
		"ВТСотрудникиПериоды");
	КадровыеДанные = "ФИОПолные,ФамилияИО,АдресПоПропискеПредставление,ДокументПредставление,Пол,Страна,КоличествоДнейОтпускаОбщее,КлассУсловийТруда,EMailПредставление";
	КадровыйУчет.СоздатьВТКадровыеДанныеСотрудников(ОписательВременныхТаблиц, Истина, КадровыеДанные);
	
	// Получение ФИО руководителей.
	ОписательВременныхТаблиц = КадровыйУчет.ОписательВременныхТаблицДляСоздатьВТКадровыеДанныеФизическихЛиц(
		Запрос.МенеджерВременныхТаблиц,
		"ВТФизическиеЛицаПериоды");
	КадровыеДанные = "ФИОПолные,ФамилияИО,Пол";
	КадровыйУчет.СоздатьВТКадровыеДанныеФизическихЛиц(ОписательВременныхТаблиц, Истина, КадровыеДанные);
	
	ТаблицаНачислений = КадровыйУчет.ТаблицаНачисленийСотрудниковПоВременнойТаблице(Запрос.МенеджерВременныхТаблиц, "ВТСотрудникиПериоды", , , , Ложь, Истина);
	
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ДанныеПриказаОПриеме.Организация,
		|	ДанныеПриказаОПриеме.ПриказОПриемеДата КАК Период
		|ИЗ
		|	ВТДанныеПриказаОПриеме КАК ДанныеПриказаОПриеме";
	
	СведенияОбОрганизациях = Новый ТаблицаЗначений;
	СведенияОбОрганизациях.Колонки.Добавить("Организация", Новый ОписаниеТипов("СправочникСсылка.Организации"));
	СведенияОбОрганизациях.Колонки.Добавить("Период", Новый ОписаниеТипов("Дата"));
	СведенияОбОрганизациях.Колонки.Добавить("НаименованиеПолное", Новый ОписаниеТипов("Строка"));
	СведенияОбОрганизациях.Колонки.Добавить("ИНН", Новый ОписаниеТипов("Строка"));
	СведенияОбОрганизациях.Колонки.Добавить("КПП", Новый ОписаниеТипов("Строка"));
	СведенияОбОрганизациях.Колонки.Добавить("ТелефонОрганизации", Новый ОписаниеТипов("Строка"));
	СведенияОбОрганизациях.Колонки.Добавить("ФаксОрганизации", Новый ОписаниеТипов("Строка"));
	СведенияОбОрганизациях.Колонки.Добавить("АдресЮридический", Новый ОписаниеТипов("Строка"));
	СведенияОбОрганизациях.Колонки.Добавить("АдресФактический", Новый ОписаниеТипов("Строка"));
	СведенияОбОрганизациях.Колонки.Добавить("ОрганизацияГородФактическогоАдреса", Новый ОписаниеТипов("Строка"));
	
	РезультатЗапросаПоШапке = Запрос.Выполнить();
	
	АдресаОрганизаций = УправлениеКонтактнойИнформациейЗарплатаКадры.АдресаОрганизаций(РезультатЗапросаПоШапке.Выгрузить().ВыгрузитьКолонку("Организация"));
	
	Выборка = РезультатЗапросаПоШапке.Выбрать();
	Пока Выборка.Следующий() Цикл
		
		НоваяСтрокаСведенияОбОрганизациях = СведенияОбОрганизациях.Добавить();
		
		Сведения = Новый СписокЗначений;
		Сведения.Добавить("", "НаимЮЛПол");
		Сведения.Добавить("", "ИННЮЛ");
		Сведения.Добавить("", "КППЮЛ");
		Сведения.Добавить("", "ТелОрганизации");
		Сведения.Добавить("", "ФаксОрганизации");
		
		УстановитьПривилегированныйРежим(Истина);
		ОргСведения = РегламентированнаяОтчетностьВызовСервера.ПолучитьСведенияОбОрганизации(Выборка.Организация, Выборка.Период, Сведения);
		УстановитьПривилегированныйРежим(Ложь);
		
		НоваяСтрокаСведенияОбОрганизациях.Организация = Выборка.Организация;
		НоваяСтрокаСведенияОбОрганизациях.Период = Выборка.Период;
		НоваяСтрокаСведенияОбОрганизациях.НаименованиеПолное = ОргСведения.НаимЮЛПол;
		НоваяСтрокаСведенияОбОрганизациях.ИНН = ОргСведения.ИННЮЛ;
		НоваяСтрокаСведенияОбОрганизациях.КПП = ОргСведения.КППЮЛ;
		НоваяСтрокаСведенияОбОрганизациях.ТелефонОрганизации = ОргСведения.ТелОрганизации;
		НоваяСтрокаСведенияОбОрганизациях.ФаксОрганизации = ОргСведения.ФаксОрганизации;
		
		ОписаниеЮридическогоАдреса = УправлениеКонтактнойИнформациейЗарплатаКадры.АдресОрганизации(
			АдресаОрганизаций,
			Выборка.Организация,
			Справочники.ВидыКонтактнойИнформации.ЮрАдресОрганизации);
		НоваяСтрокаСведенияОбОрганизациях.АдресЮридический = ОписаниеЮридическогоАдреса.Представление;
		
		ОписаниеФактическогоАдреса = УправлениеКонтактнойИнформациейЗарплатаКадры.АдресОрганизации(
			АдресаОрганизаций,
			Выборка.Организация,
			Справочники.ВидыКонтактнойИнформации.ФактАдресОрганизации);
		НоваяСтрокаСведенияОбОрганизациях.АдресФактический = ОписаниеФактическогоАдреса.Представление;
		НоваяСтрокаСведенияОбОрганизациях.ОрганизацияГородФактическогоАдреса = ОписаниеФактическогоАдреса.Город;
		
	КонецЦикла;
	
	Запрос.УстановитьПараметр("СведенияОбОрганизациях", СведенияОбОрганизациях);
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	СведенияОбОрганизациях.Период,
		|	СведенияОбОрганизациях.Организация,
		|	СведенияОбОрганизациях.НаименованиеПолное КАК ОрганизацияНаименованиеПолное,
		|	СведенияОбОрганизациях.ИНН КАК ИНН,
		|	СведенияОбОрганизациях.КПП КАК КПП,
		|	СведенияОбОрганизациях.ТелефонОрганизации КАК ТелефонОрганизации,
		|	СведенияОбОрганизациях.ФаксОрганизации КАК ФаксОрганизации,
		|	СведенияОбОрганизациях.АдресЮридический КАК ОрганизацияАдресЮридический,
		|	СведенияОбОрганизациях.АдресФактический КАК ОрганизацияАдресФактический,
		|	СведенияОбОрганизациях.ОрганизацияГородФактическогоАдреса КАК ОрганизацияГородФактическогоАдреса
		|ПОМЕСТИТЬ ВТДанныеОрганизаций
		|ИЗ
		|	&СведенияОбОрганизациях КАК СведенияОбОрганизациях
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ДанныеПриказаОПриеме.Ссылка,
		|	ДанныеПриказаОПриеме.ПриказОПриемеНомер,
		|	ДанныеПриказаОПриеме.ПриказОПриемеДата,
		|	ДанныеПриказаОПриеме.Подразделение,
		|	ДанныеПриказаОПриеме.Должность,
		|	ДанныеПриказаОПриеме.Сотрудник,
		|	ДанныеПриказаОПриеме.ВидЗанятости,
		|	ДанныеПриказаОПриеме.ТрудовойДоговорНомер,
		|	ДанныеПриказаОПриеме.ТрудовойДоговорДата,
		|	ДанныеПриказаОПриеме.ДолжностьРуководителя КАК РуководительДолжность,
		|	ДанныеПриказаОПриеме.ДатаПриема,
		|	ДанныеПриказаОПриеме.ДатаЗавершенияТрудовогоДоговора,
		|	ВЫБОР
		|		КОГДА КадровыеДанныеСотрудников.Страна = ЗНАЧЕНИЕ(Справочник.СтраныМира.Россия)
		|			ТОГДА """"
		|		ИНАЧЕ ДанныеПриказаОПриеме.РазрешениеНаРаботу
		|	КОНЕЦ КАК РазрешениеНаРаботу,
		|	ВЫБОР
		|		КОГДА КадровыеДанныеСотрудников.Страна = ЗНАЧЕНИЕ(Справочник.СтраныМира.Россия)
		|			ТОГДА """"
		|		ИНАЧЕ ДанныеПриказаОПриеме.РазрешениеНаПроживание
		|	КОНЕЦ КАК РазрешениеНаПроживание,
		|	ВЫБОР
		|		КОГДА КадровыеДанныеСотрудников.Страна = ЗНАЧЕНИЕ(Справочник.СтраныМира.Россия)
		|			ТОГДА """"
		|		ИНАЧЕ ДанныеПриказаОПриеме.УсловияОказанияМедпомощи
		|	КОНЕЦ КАК УсловияОказанияМедпомощи,
		|	ДанныеПриказаОПриеме.ОснованиеПредставителяНанимателя,
		|	ДанныеПриказаОПриеме.ОборудованиеРабочегоМеста,
		|	ДанныеПриказаОПриеме.ИныеУсловияДоговора,
		|	ДанныеОрганизаций.Организация,
		|	ДанныеОрганизаций.ОрганизацияНаименованиеПолное,
		|	ДанныеОрганизаций.ИНН,
		|	ДанныеОрганизаций.КПП,
		|	ДанныеОрганизаций.ТелефонОрганизации,
		|	ДанныеОрганизаций.ФаксОрганизации,
		|	ДанныеОрганизаций.ОрганизацияАдресЮридический,
		|	ДанныеОрганизаций.ОрганизацияАдресФактический,
		|	ДанныеОрганизаций.ОрганизацияГородФактическогоАдреса,
		|	КадровыеДанныеСотрудников.Страна,
		|	КадровыеДанныеФизическихЛиц.ФИОПолные КАК РуководительФИОПолные,
		|	КадровыеДанныеФизическихЛиц.ФамилияИО КАК РуководительФамилияИО,
		|	КадровыеДанныеФизическихЛиц.Пол КАК РуководительПол,
		|	КадровыеДанныеСотрудников.ФИОПолные КАК ФИОПолные,
		|	КадровыеДанныеСотрудников.ФамилияИО КАК ФамилияИО,
		|	КадровыеДанныеСотрудников.Пол КАК Пол,
		|	КадровыеДанныеСотрудников.АдресПоПропискеПредставление КАК АдресПоПропискеПредставление,
		|	КадровыеДанныеСотрудников.ДокументПредставление КАК ДокументПредставление,
		|	КадровыеДанныеСотрудников.КоличествоДнейОтпускаОбщее,
		|	КадровыеДанныеСотрудников.КлассУсловийТруда,
		|	КадровыеДанныеСотрудников.EMailПредставление КАК EMail
		|ИЗ
		|	ВТДанныеПриказаОПриеме КАК ДанныеПриказаОПриеме
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТДанныеОрганизаций КАК ДанныеОрганизаций
		|		ПО ДанныеПриказаОПриеме.Организация = ДанныеОрганизаций.Организация
		|			И ДанныеПриказаОПриеме.ПриказОПриемеДата = ДанныеОрганизаций.Период
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТКадровыеДанныеФизическихЛиц КАК КадровыеДанныеФизическихЛиц
		|		ПО ДанныеПриказаОПриеме.Руководитель = КадровыеДанныеФизическихЛиц.ФизическоеЛицо
		|			И ДанныеПриказаОПриеме.ДатаПриема = КадровыеДанныеФизическихЛиц.Период
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТКадровыеДанныеСотрудников КАК КадровыеДанныеСотрудников
		|		ПО ДанныеПриказаОПриеме.Сотрудник = КадровыеДанныеСотрудников.Сотрудник
		|			И ДанныеПриказаОПриеме.ДатаПриема = КадровыеДанныеСотрудников.Период";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		ПараметрыТрудовогоДоговора = ПараметрыТрудовогоДоговора();
		ЗаполнитьЗначенияСвойств(ПараметрыТрудовогоДоговора, Выборка);
		
		РезультатСклонения = "";
		Если ФизическиеЛицаЗарплатаКадры.Просклонять(Строка(ПараметрыТрудовогоДоговора.РуководительФИОПолные), 2, РезультатСклонения, ПараметрыТрудовогоДоговора.РуководительПол) Тогда
			ПараметрыТрудовогоДоговора.РуководительФИОПолные = РезультатСклонения
		КонецЕсли;
		
		ПараметрыТрудовогоДоговора.РуководительДолжностьВПадеже = СклонениеПредставленийОбъектов.ПросклонятьПредставление(Строка(ПараметрыТрудовогоДоговора.РуководительДолжность), 2);
		
		ПараметрыТрудовогоДоговора.ТрудовойДоговорДата = Формат(Выборка.ТрудовойДоговорДата, "Л=ru_RU; ДЛФ=DD; ДП='""___"" ____________ 20___ г.'");
		ПараметрыТрудовогоДоговора.ПриказОПриемеДата = Формат(Выборка.ПриказОПриемеДата, "ДЛФ=D; ДЛФ=DD");
		ПараметрыТрудовогоДоговора.ДатаПриема = Формат(Выборка.ДатаПриема, "ДЛФ=D; ДЛФ=DD");
		
		ОплатаТруда = "";
		СтрокиНачислений = ТаблицаНачислений.НайтиСтроки(Новый Структура("Сотрудник,Период", Выборка.Сотрудник, Выборка.ДатаПриема));
		Если СтрокиНачислений.Количество() > 0 Тогда
			
			Если Не ПустаяСтрока(СтрокиНачислений[0].ОписаниеОклада) Тогда
				ОплатаТруда = СтрокиНачислений[0].ОписаниеОклада;
			КонецЕсли;
		
			Если ЗначениеЗаполнено(СтрокиНачислений[0].Надбавка) Тогда
				ОплатаТруда = ?(ПустаяСтрока(ОплатаТруда), "", ОплатаТруда + "; ") + СтрокиНачислений[0].Надбавка;
			КонецЕсли;
			
		КонецЕсли;
		
		Если ПустаяСтрока(ОплатаТруда) Тогда
			ОплатаТруда = Символы.ПС + "_____________________________________________________________________________________";
		КонецЕсли;
		
		УсловияОплатыТруда = НСтр("ru='Согласно настоящему договору Работнику выплачивается заработная плата'");
		Если ПолучитьФункциональнуюОпцию("ИспользоватьШтатноеРасписание") Тогда
			УсловияОплатыТруда = УсловияОплатыТруда + " " + НСтр("ru='в соответствии со штатным расписанием'");
		КонецЕсли;
		
		УсловияОплатыТруда = УсловияОплатыТруда + ".";
		
		УсловияОплатыТруда = УсловияОплатыТруда + " " + НСтр("ru='На момент заключения договора заработная плата состоит из'") + ": " + ОплатаТруда;
		ПараметрыТрудовогоДоговора.УсловияОплатыТруда = УсловияОплатыТруда + ?(Прав(УсловияОплатыТруда, 1) = ".", "", ".");
		ПараметрыТрудовогоДоговора.УсловияОплатыТруда = ОплатаТруда;
		
		Если ЗначениеЗаполнено(Выборка.КлассУсловийТруда) Тогда
			
			Если Выборка.КлассУсловийТруда = Перечисления.КлассыУсловийТрудаПоРезультатамСпециальнойОценки.Оптимальный Тогда
				
				ПараметрыТрудовогоДоговора.УсловияТруда = НСтр("ru='оптимальными'");
				ПараметрыТрудовогоДоговора.КлассУсловий = НСтр("ru='1 класс'");
				
			ИначеЕсли Выборка.КлассУсловийТруда = Перечисления.КлассыУсловийТрудаПоРезультатамСпециальнойОценки.Допустимый Тогда
				
				ПараметрыТрудовогоДоговора.УсловияТруда = НСтр("ru='допустимыми'");
				ПараметрыТрудовогоДоговора.КлассУсловий = НСтр("ru='2 класс'");
				
			ИначеЕсли Выборка.КлассУсловийТруда = Перечисления.КлассыУсловийТрудаПоРезультатамСпециальнойОценки.Вредный1 Тогда
				
				ПараметрыТрудовогоДоговора.УсловияТруда = НСтр("ru='вредными'");
				ПараметрыТрудовогоДоговора.КлассУсловий = НСтр("ru='3 класс, подкласс 3.1 (вредные условия труда 1 степени)'");
				
			ИначеЕсли Выборка.КлассУсловийТруда = Перечисления.КлассыУсловийТрудаПоРезультатамСпециальнойОценки.Вредный2 Тогда
				
				ПараметрыТрудовогоДоговора.УсловияТруда = НСтр("ru='вредными'");
				ПараметрыТрудовогоДоговора.КлассУсловий = НСтр("ru='3 класс, подкласс 3.2 (вредные условия труда 2 степени)'");
				
			ИначеЕсли Выборка.КлассУсловийТруда = Перечисления.КлассыУсловийТрудаПоРезультатамСпециальнойОценки.Вредный3 Тогда
				
				ПараметрыТрудовогоДоговора.УсловияТруда = НСтр("ru='вредными'");
				ПараметрыТрудовогоДоговора.КлассУсловий = НСтр("ru='3 класс, подкласс 3.3 (вредные условия труда 3 степени)'");
				
			ИначеЕсли Выборка.КлассУсловийТруда = Перечисления.КлассыУсловийТрудаПоРезультатамСпециальнойОценки.Вредный4 Тогда
				
				ПараметрыТрудовогоДоговора.УсловияТруда = НСтр("ru='вредными'");
				ПараметрыТрудовогоДоговора.КлассУсловий = НСтр("ru='3 класс, подкласс 3.4 (вредные условия труда 4 степени)'");
				
			ИначеЕсли Выборка.КлассУсловийТруда = Перечисления.КлассыУсловийТрудаПоРезультатамСпециальнойОценки.Опасный Тогда
				
				ПараметрыТрудовогоДоговора.УсловияТруда = НСтр("ru='опасными'");
				ПараметрыТрудовогоДоговора.КлассУсловий = НСтр("ru='4 класс'");
				
			КонецЕсли;
			
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(ПараметрыТрудовогоДоговора.УсловияТруда) Тогда
			
			ПараметрыТрудовогоДоговора.УсловияТруда = "_____________";
			ПараметрыТрудовогоДоговора.КлассУсловий = "_____________";
			
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Выборка.ОснованиеПредставителяНанимателя) Тогда
			ПараметрыТрудовогоДоговора.ОснованиеРуководителя = Выборка.ОснованиеПредставителяНанимателя;
		Иначе
			ПараметрыТрудовогоДоговора.ОснованиеРуководителя = "__________________";
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Выборка.ОборудованиеРабочегоМеста) Тогда
			ПараметрыТрудовогоДоговора.ОборудованиеРабочегоМеста = " (" + Выборка.ОборудованиеРабочегоМеста + ")"
		Иначе
			ПараметрыТрудовогоДоговора.ОборудованиеРабочегоМеста = "";
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Выборка.ИныеУсловияДоговора) Тогда
			
			Если ИмяМакета = "ПФ_MXL_ТрудовойДоговорПриДистанционнойРаботе" Тогда
				ПараметрыТрудовогоДоговора.ИныеУсловияДоговора = "8.5.";
			Иначе
				ПараметрыТрудовогоДоговора.ИныеУсловияДоговора = "7.3.";
			КонецЕсли;
			
			ПараметрыТрудовогоДоговора.ИныеУсловияДоговора = ПараметрыТрудовогоДоговора.ИныеУсловияДоговора + " " + Выборка.ИныеУсловияДоговора + ".";
			
		Иначе
			ПараметрыТрудовогоДоговора.ИныеУсловияДоговора = "";
		КонецЕсли;
		
		Если Выборка.ВидЗанятости = Перечисления.ВидыЗанятости.ОсновноеМестоРаботы Тогда
			ПараметрыТрудовогоДоговора.ВидЗанятостиПоДоговору = НСтр("ru='основному месту работы'");
		Иначе
			ПараметрыТрудовогоДоговора.ВидЗанятостиПоДоговору = НСтр("ru='работе по совместительству'");
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Выборка.ДатаЗавершенияТрудовогоДоговора) Тогда
			
			ПараметрыТрудовогоДоговора.СрокДействияПредставление = НСтр("ru='на определенный срок'");
			ПараметрыТрудовогоДоговора.Вставить("ДатаУвольнения", Формат(Выборка.ДатаЗавершенияТрудовогоДоговора, "ДЛФ=D"));
				
			Если Прав(ПараметрыТрудовогоДоговора.СрокДействияПредставление, 1) = "." Тогда
				ПараметрыТрудовогоДоговора.СрокДействияПредставление =
					Лев(ПараметрыТрудовогоДоговора.СрокДействияПредставление, СтрДлина(ПараметрыТрудовогоДоговора.СрокДействияПредставление) - 1);
			КонецЕсли;
				
		Иначе
			ПараметрыТрудовогоДоговора.СрокДействияПредставление = НСтр("ru='на неопределенный срок'");
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(ПараметрыТрудовогоДоговора.КоличествоДнейОтпускаОбщее) Тогда
			ПараметрыТрудовогоДоговора.КоличествоДнейОтпускаОбщее = "____";
		КонецЕсли;
		
		Если ПараметрыТрудовогоДоговора.Страна <> Справочники.СтраныМира.Россия Тогда
			
			Если Не ЗначениеЗаполнено(ПараметрыТрудовогоДоговора.РазрешениеНаРаботу) Тогда
				ПараметрыТрудовогоДоговора.РазрешениеНаРаботу = Символы.ПС
					+ "______________________________________________________________________________________";
			КонецЕсли;
			
			Если Не ЗначениеЗаполнено(ПараметрыТрудовогоДоговора.РазрешениеНаПроживание) Тогда
				ПараметрыТрудовогоДоговора.РазрешениеНаПроживание = Символы.ПС
					+ "______________________________________________________________________________________";
			КонецЕсли;
			
			Если Не ЗначениеЗаполнено(ПараметрыТрудовогоДоговора.УсловияОказанияМедпомощи) Тогда
				ПараметрыТрудовогоДоговора.УсловияОказанияМедпомощи = Символы.ПС
					+ "______________________________________________________________________________________";
			КонецЕсли;
			
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Выборка.Организация) Тогда
			
			ПараметрыТрудовогоДоговора.ИННКПП =
				НСтр("ru='ИНН'") + ":  " + ?(ЗначениеЗаполнено(Выборка.ИНН), Выборка.ИНН, "_____________");
				
			Если ЗарплатаКадры.ЭтоЮридическоеЛицо(Выборка.Организация) Тогда
				
				ПараметрыТрудовогоДоговора.ИННКПП = ПараметрыТрудовогоДоговора.ИННКПП +
					" " + НСтр("ru='КПП'") + ": " + ?(ЗначениеЗаполнено(Выборка.КПП), Выборка.КПП, "_____________");
				
			КонецЕсли;
			
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(Выборка.РуководительДолжность) Тогда
			ПараметрыТрудовогоДоговора.РуководительДолжность = "__________________________";
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(Выборка.РуководительФамилияИО) Тогда
			ПараметрыТрудовогоДоговора.РуководительФамилияИО = "__________________________";
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Выборка.ТелефонОрганизации) Тогда
			ПараметрыТрудовогоДоговора.ОрганизацияТелефон = Выборка.ТелефонОрганизации;
		Иначе
			ПараметрыТрудовогоДоговора.ОрганизацияТелефон = "__________________________";
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Выборка.ФаксОрганизации) Тогда
			
			ПараметрыТрудовогоДоговора.ОрганизацияТелефон = ПараметрыТрудовогоДоговора.ОрганизацияТелефон +
				" " + НСтр("ru='Факс'") + ": " + Выборка.ФаксОрганизации;
			
		КонецЕсли;
		
		МассивПараметров = ДанныеДляПечати.Получить(ПараметрыТрудовогоДоговора.Ссылка);
		Если МассивПараметров = Неопределено Тогда
			
			МассивПараметров = Новый Массив;
			ДанныеДляПечати.Вставить(ПараметрыТрудовогоДоговора.Ссылка, МассивПараметров);
			
		КонецЕсли;
		
		МассивПараметров.Добавить(ПараметрыТрудовогоДоговора);
		
	КонецЦикла;
УстановитьПривилегированныйРежим(Ложь);	
	Возврат ДанныеДляПечати;
	
КонецФункции

Функция ПараметрыТрудовогоДоговора()
	
	Параметры = Новый Структура;
	
	Параметры.Вставить("Ссылка", Неопределено);
	Параметры.Вставить("ПриказОПриемеНомер", "");
	Параметры.Вставить("ПриказОПриемеДата", '00010101');
	Параметры.Вставить("ОрганизацияНаименованиеПолное", "");
	Параметры.Вставить("ИННКПП", "");
	Параметры.Вставить("ОрганизацияТелефон", "");
	Параметры.Вставить("ОрганизацияАдресЮридический", "");
	Параметры.Вставить("ОрганизацияАдресФактический", "");
	Параметры.Вставить("ОрганизацияГородФактическогоАдреса", "");
	Параметры.Вставить("Сотрудник", Справочники.Сотрудники.ПустаяСсылка());
	Параметры.Вставить("Подразделение", Справочники.ПодразделенияОрганизаций.ПустаяСсылка());
	Параметры.Вставить("Должность", Справочники.Должности.ПустаяСсылка());
	Параметры.Вставить("ВидЗанятостиПоДоговору", "");
	Параметры.Вставить("ТрудовойДоговорНомер", "");
	Параметры.Вставить("ТрудовойДоговорДата", '00010101');
	Параметры.Вставить("СрокДействияПредставление", "");
	Параметры.Вставить("РуководительФамилияИО", "");
	Параметры.Вставить("РуководительФИОПолные", "");
	Параметры.Вставить("РуководительПол");
	Параметры.Вставить("РуководительДолжность", Справочники.Должности.ПустаяСсылка());
	Параметры.Вставить("ДатаПриема", '00010101');
	Параметры.Вставить("ФИОПолные", "");
	Параметры.Вставить("ФамилияИО", "");
	Параметры.Вставить("Пол");
	Параметры.Вставить("КлассУсловийТруда");
	Параметры.Вставить("УсловияТруда", "");
	Параметры.Вставить("КлассУсловий", "");
	Параметры.Вставить("АдресПоПропискеПредставление", "");
	Параметры.Вставить("ДокументПредставление", "");
	Параметры.Вставить("Страна", Справочники.СтраныМира.Россия);
	Параметры.Вставить("РазрешениеНаРаботу", "");
	Параметры.Вставить("РазрешениеНаПроживание", "");
	Параметры.Вставить("УсловияОказанияМедпомощи", "");
	Параметры.Вставить("КоличествоДнейОтпускаОбщее", "");
	Параметры.Вставить("ОснованиеРуководителя", "");
	Параметры.Вставить("ОборудованиеРабочегоМеста", "");
	Параметры.Вставить("ИныеУсловияДоговора", "");
	Параметры.Вставить("РуководительДолжностьВПадеже", "");
	Параметры.Вставить("УсловияОплатыТруда");
	Параметры.Вставить("EMail");
	
	Возврат Параметры;
	
КонецФункции
