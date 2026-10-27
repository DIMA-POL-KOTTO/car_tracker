import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru'),
  ];

  /// No description provided for @home_page.
  ///
  /// In ru, this message translates to:
  /// **'Главная'**
  String get home_page;

  /// No description provided for @fuel_page.
  ///
  /// In ru, this message translates to:
  /// **'Заправки'**
  String get fuel_page;

  /// No description provided for @maintenance_page.
  ///
  /// In ru, this message translates to:
  /// **'ТО'**
  String get maintenance_page;

  /// No description provided for @more_page.
  ///
  /// In ru, this message translates to:
  /// **'Ещё'**
  String get more_page;

  /// No description provided for @update_btn.
  ///
  /// In ru, this message translates to:
  /// **'Обновить'**
  String get update_btn;

  /// No description provided for @current_mileage.
  ///
  /// In ru, this message translates to:
  /// **'Текущий пробег'**
  String get current_mileage;

  /// No description provided for @year_point.
  ///
  /// In ru, this message translates to:
  /// **'г.'**
  String get year_point;

  /// No description provided for @km.
  ///
  /// In ru, this message translates to:
  /// **'км'**
  String get km;

  /// No description provided for @mi.
  ///
  /// In ru, this message translates to:
  /// **'миль'**
  String get mi;

  /// No description provided for @settings.
  ///
  /// In ru, this message translates to:
  /// **'Настройки'**
  String get settings;

  /// No description provided for @add_fuel_page.
  ///
  /// In ru, this message translates to:
  /// **'Добавить заправку'**
  String get add_fuel_page;

  /// No description provided for @fuel_page_photo_btn_h.
  ///
  /// In ru, this message translates to:
  /// **'Сфотографировать чек'**
  String get fuel_page_photo_btn_h;

  /// No description provided for @fuel_page_photo_btn_p.
  ///
  /// In ru, this message translates to:
  /// **'Данные будут распознаны автоматически'**
  String get fuel_page_photo_btn_p;

  /// No description provided for @fuel_page_manual_btn_h.
  ///
  /// In ru, this message translates to:
  /// **'Ввести вручную'**
  String get fuel_page_manual_btn_h;

  /// No description provided for @fuel_page_manual_btn_p.
  ///
  /// In ru, this message translates to:
  /// **'Самостоятельно указать данные заправки'**
  String get fuel_page_manual_btn_p;

  /// No description provided for @fuel_form.
  ///
  /// In ru, this message translates to:
  /// **'Данные заправки'**
  String get fuel_form;

  /// No description provided for @fuel_station.
  ///
  /// In ru, this message translates to:
  /// **'АЗС'**
  String get fuel_station;

  /// No description provided for @fuel_date.
  ///
  /// In ru, this message translates to:
  /// **'Дата'**
  String get fuel_date;

  /// No description provided for @fuel_type.
  ///
  /// In ru, this message translates to:
  /// **'Топливо'**
  String get fuel_type;

  /// No description provided for @fuel_amount.
  ///
  /// In ru, this message translates to:
  /// **'Количество'**
  String get fuel_amount;

  /// No description provided for @fuel_price.
  ///
  /// In ru, this message translates to:
  /// **'Цена за'**
  String get fuel_price;

  /// No description provided for @liter.
  ///
  /// In ru, this message translates to:
  /// **'литр'**
  String get liter;

  /// No description provided for @l.
  ///
  /// In ru, this message translates to:
  /// **'л'**
  String get l;

  /// No description provided for @fuel_total_cost.
  ///
  /// In ru, this message translates to:
  /// **'Общая стоимость'**
  String get fuel_total_cost;

  /// No description provided for @fuel_mileage.
  ///
  /// In ru, this message translates to:
  /// **'Пробег'**
  String get fuel_mileage;

  /// No description provided for @language.
  ///
  /// In ru, this message translates to:
  /// **'Язык'**
  String get language;

  /// No description provided for @russian_lang.
  ///
  /// In ru, this message translates to:
  /// **'Русский'**
  String get russian_lang;

  /// No description provided for @english_lang.
  ///
  /// In ru, this message translates to:
  /// **'Английский'**
  String get english_lang;

  /// No description provided for @theme.
  ///
  /// In ru, this message translates to:
  /// **'Тема'**
  String get theme;

  /// No description provided for @light.
  ///
  /// In ru, this message translates to:
  /// **'Светлая'**
  String get light;

  /// No description provided for @dark.
  ///
  /// In ru, this message translates to:
  /// **'Тёмная'**
  String get dark;

  /// No description provided for @notifications.
  ///
  /// In ru, this message translates to:
  /// **'Уведомления'**
  String get notifications;

  /// No description provided for @change.
  ///
  /// In ru, this message translates to:
  /// **'Изменить'**
  String get change;

  /// No description provided for @delete.
  ///
  /// In ru, this message translates to:
  /// **'Удалить'**
  String get delete;

  /// No description provided for @last_refill.
  ///
  /// In ru, this message translates to:
  /// **'Последняя заправка'**
  String get last_refill;

  /// No description provided for @update_mileage.
  ///
  /// In ru, this message translates to:
  /// **'Обновить пробег'**
  String get update_mileage;

  /// No description provided for @cancel.
  ///
  /// In ru, this message translates to:
  /// **'Отмена'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In ru, this message translates to:
  /// **'Сохранить'**
  String get save;

  /// No description provided for @no_refills_yet.
  ///
  /// In ru, this message translates to:
  /// **'Заправок пока нет'**
  String get no_refills_yet;

  /// No description provided for @selected.
  ///
  /// In ru, this message translates to:
  /// **'Выбрано'**
  String get selected;

  /// No description provided for @failed_to_load_reminders.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось загрузить напоминания'**
  String get failed_to_load_reminders;

  /// No description provided for @repeate.
  ///
  /// In ru, this message translates to:
  /// **'Повторить'**
  String get repeate;

  /// No description provided for @no_maintenance_reminders_yet.
  ///
  /// In ru, this message translates to:
  /// **'Пока нет напоминаний о техобслуживании'**
  String get no_maintenance_reminders_yet;

  /// No description provided for @reminders.
  ///
  /// In ru, this message translates to:
  /// **'Напоминания'**
  String get reminders;

  /// No description provided for @history.
  ///
  /// In ru, this message translates to:
  /// **'История'**
  String get history;

  /// No description provided for @ron_92.
  ///
  /// In ru, this message translates to:
  /// **'АИ-92'**
  String get ron_92;

  /// No description provided for @ron_95.
  ///
  /// In ru, this message translates to:
  /// **'АИ-95'**
  String get ron_95;

  /// No description provided for @ron_98.
  ///
  /// In ru, this message translates to:
  /// **'АИ-98'**
  String get ron_98;

  /// No description provided for @ron_100.
  ///
  /// In ru, this message translates to:
  /// **'АИ-100'**
  String get ron_100;

  /// No description provided for @diesel.
  ///
  /// In ru, this message translates to:
  /// **'Дизель'**
  String get diesel;

  /// No description provided for @gas.
  ///
  /// In ru, this message translates to:
  /// **'Газ'**
  String get gas;

  /// No description provided for @electric.
  ///
  /// In ru, this message translates to:
  /// **'Электро'**
  String get electric;

  /// No description provided for @petrol.
  ///
  /// In ru, this message translates to:
  /// **'Бензин'**
  String get petrol;

  /// No description provided for @january.
  ///
  /// In ru, this message translates to:
  /// **'Январь'**
  String get january;

  /// No description provided for @february.
  ///
  /// In ru, this message translates to:
  /// **'Февраль'**
  String get february;

  /// No description provided for @march.
  ///
  /// In ru, this message translates to:
  /// **'Март'**
  String get march;

  /// No description provided for @april.
  ///
  /// In ru, this message translates to:
  /// **'Апрель'**
  String get april;

  /// No description provided for @may.
  ///
  /// In ru, this message translates to:
  /// **'Май'**
  String get may;

  /// No description provided for @june.
  ///
  /// In ru, this message translates to:
  /// **'Июнь'**
  String get june;

  /// No description provided for @july.
  ///
  /// In ru, this message translates to:
  /// **'Июль'**
  String get july;

  /// No description provided for @august.
  ///
  /// In ru, this message translates to:
  /// **'Август'**
  String get august;

  /// No description provided for @september.
  ///
  /// In ru, this message translates to:
  /// **'Сентябрь'**
  String get september;

  /// No description provided for @october.
  ///
  /// In ru, this message translates to:
  /// **'Октябрь'**
  String get october;

  /// No description provided for @november.
  ///
  /// In ru, this message translates to:
  /// **'Ноябрь'**
  String get november;

  /// No description provided for @december.
  ///
  /// In ru, this message translates to:
  /// **'Декабрь'**
  String get december;

  /// No description provided for @refilling_information.
  ///
  /// In ru, this message translates to:
  /// **'Информация о заправке'**
  String get refilling_information;

  /// No description provided for @organization.
  ///
  /// In ru, this message translates to:
  /// **'Организация'**
  String get organization;

  /// No description provided for @for_example.
  ///
  /// In ru, this message translates to:
  /// **'Например'**
  String get for_example;

  /// No description provided for @belorusneft.
  ///
  /// In ru, this message translates to:
  /// **'Белоруснефть'**
  String get belorusneft;

  /// No description provided for @grodno.
  ///
  /// In ru, this message translates to:
  /// **'Гродно'**
  String get grodno;

  /// No description provided for @town_point.
  ///
  /// In ru, this message translates to:
  /// **'г.'**
  String get town_point;

  /// No description provided for @fuel_data.
  ///
  /// In ru, this message translates to:
  /// **'Данные топлива'**
  String get fuel_data;

  /// No description provided for @add.
  ///
  /// In ru, this message translates to:
  /// **'Добавить'**
  String get add;

  /// No description provided for @fill_in_the_required_fields.
  ///
  /// In ru, this message translates to:
  /// **'Заполните обязательные поля'**
  String get fill_in_the_required_fields;

  /// No description provided for @new_reminder.
  ///
  /// In ru, this message translates to:
  /// **'Новое напоминание'**
  String get new_reminder;

  /// No description provided for @editing.
  ///
  /// In ru, this message translates to:
  /// **'Редактирование'**
  String get editing;

  /// No description provided for @maintenance_name.
  ///
  /// In ru, this message translates to:
  /// **'Название ТО'**
  String get maintenance_name;

  /// No description provided for @oil_change.
  ///
  /// In ru, this message translates to:
  /// **'Замена масла'**
  String get oil_change;

  /// No description provided for @enter_maintenance_name.
  ///
  /// In ru, this message translates to:
  /// **'Введите название ТО'**
  String get enter_maintenance_name;

  /// No description provided for @category.
  ///
  /// In ru, this message translates to:
  /// **'Категория'**
  String get category;

  /// No description provided for @enter_categoty.
  ///
  /// In ru, this message translates to:
  /// **'Выберите категорию'**
  String get enter_categoty;

  /// No description provided for @repeate_maintenance.
  ///
  /// In ru, this message translates to:
  /// **'Повторять ТО'**
  String get repeate_maintenance;

  /// No description provided for @reminder_type.
  ///
  /// In ru, this message translates to:
  /// **'Тип напоминания'**
  String get reminder_type;

  /// No description provided for @by_mileage.
  ///
  /// In ru, this message translates to:
  /// **'По пробегу'**
  String get by_mileage;

  /// No description provided for @by_date.
  ///
  /// In ru, this message translates to:
  /// **'По дате'**
  String get by_date;

  /// No description provided for @enter_current_mileage.
  ///
  /// In ru, this message translates to:
  /// **'Введите текущий пробег'**
  String get enter_current_mileage;

  /// No description provided for @interval.
  ///
  /// In ru, this message translates to:
  /// **'Интервал'**
  String get interval;

  /// No description provided for @enter_a_valid_interval.
  ///
  /// In ru, this message translates to:
  /// **'Введите корректный интервал'**
  String get enter_a_valid_interval;

  /// No description provided for @next_mileage.
  ///
  /// In ru, this message translates to:
  /// **'Следующий пробег'**
  String get next_mileage;

  /// No description provided for @calculated_automatically.
  ///
  /// In ru, this message translates to:
  /// **'Рассчитывается автоматически'**
  String get calculated_automatically;

  /// No description provided for @enter_next_mileage.
  ///
  /// In ru, this message translates to:
  /// **'Введите следущий пробег'**
  String get enter_next_mileage;

  /// No description provided for @mileage_cannot_be_less_than_current.
  ///
  /// In ru, this message translates to:
  /// **'Пробег не может быть меньше текущего'**
  String get mileage_cannot_be_less_than_current;

  /// No description provided for @mon_point.
  ///
  /// In ru, this message translates to:
  /// **'мес.'**
  String get mon_point;

  /// No description provided for @next_date.
  ///
  /// In ru, this message translates to:
  /// **'Следующая дата'**
  String get next_date;

  /// No description provided for @complete.
  ///
  /// In ru, this message translates to:
  /// **'Выполнить'**
  String get complete;

  /// No description provided for @completing.
  ///
  /// In ru, this message translates to:
  /// **'Выполнение'**
  String get completing;

  /// No description provided for @maintenance_being_performed.
  ///
  /// In ru, this message translates to:
  /// **'Выполняемое ТО'**
  String get maintenance_being_performed;

  /// No description provided for @check_the_selected_reminder.
  ///
  /// In ru, this message translates to:
  /// **'Проверьте выбранное напоминание'**
  String get check_the_selected_reminder;

  /// No description provided for @completing_details.
  ///
  /// In ru, this message translates to:
  /// **'Детали выполнения'**
  String get completing_details;

  /// No description provided for @enter_a_valid_cost.
  ///
  /// In ru, this message translates to:
  /// **'Введите корректную стоимость'**
  String get enter_a_valid_cost;

  /// No description provided for @comment.
  ///
  /// In ru, this message translates to:
  /// **'Комментарий'**
  String get comment;

  /// No description provided for @add_a_note_about_the_work_performed.
  ///
  /// In ru, this message translates to:
  /// **'Добавьте заметку о выполненных работах'**
  String get add_a_note_about_the_work_performed;

  /// No description provided for @saving.
  ///
  /// In ru, this message translates to:
  /// **'Сохранение...'**
  String get saving;

  /// No description provided for @enter_a_valid_mileage.
  ///
  /// In ru, this message translates to:
  /// **'Введите корректный пробег'**
  String get enter_a_valid_mileage;

  /// No description provided for @cost.
  ///
  /// In ru, this message translates to:
  /// **'Стоимость'**
  String get cost;

  /// No description provided for @next_maintenance.
  ///
  /// In ru, this message translates to:
  /// **'Следующее ТО'**
  String get next_maintenance;

  /// No description provided for @history_details.
  ///
  /// In ru, this message translates to:
  /// **'Выполненное ТО'**
  String get history_details;

  /// No description provided for @maintenance_details.
  ///
  /// In ru, this message translates to:
  /// **'Сведения о выполнении'**
  String get maintenance_details;

  /// No description provided for @not_specified.
  ///
  /// In ru, this message translates to:
  /// **'Не указано'**
  String get not_specified;

  /// No description provided for @nearest_maintenance.
  ///
  /// In ru, this message translates to:
  /// **'Ближайшие обслуживания'**
  String get nearest_maintenance;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
