import 'package:font_awesome_flutter/font_awesome_flutter.dart';

const Map dari = {
  'login': 'وارد شوید',
  'signOut': 'خروج',
  'email': 'ایمیل آدرس',
  'password': 'پسورد',
  'register': 'راجستر نمائید!',
  'haveAnAccount': 'اګر حساب دارید، ',
  'doNotHaveAnAccount': 'اګر حساب ندارید، ',
  'phone': 'نمبر تیلفون (اختیاری)',
  'name': 'نام کاربری',
  'signinWithFacebook': 'ورود با فیسبوک',
  'signinWithGoogle': 'ورود با ګوګل',
  'registerWithFacebook': 'ثبت نام با فیسبوک',
  'registerWithGoogle': 'ثبت نام با ګوګل',

  'more': 'ادامه...',

  // ToolBar and Main Screen
  'home': 'خانه',
  'market': 'بازار',
  'messages': 'پیام ها',
  'me': 'من',
  'services': 'خدمات',

  // post/advert actions buttons

  'text': 'پیام',
  'call': 'زنګ',
  'comment': 'تبصره',
  'hide': 'پنهان',
  'like': 'پسندیدن',

  //////////////// post //////////////////

  'advert': 'اعلان',
  'general': 'عمومی',
  'lost': 'مفقودی',
  'found': 'پیدا شده',
  'emergency': 'عاجل',

  'singleComment': 'تبصره',
  'multiComments': 'تبصره',
  'addComment': 'تبصره...',

  'addNewPost': 'پوست جدید بنویس!',

  'jobs': 'وظیفه',
  'send': 'ارسال',
  'typeOfTransaction': 'نوع معامله',
  'postTitle': 'عنوان...',
  'advertPostTitle': 'عنوان(اجباری): (مثلاً موتر فروشی، خانه کرایی و غیره...)',
  'advertPostDiscription':
      'تشریح(اجباری): (مثلا رنګ، سال، مستعمل، جدید و غیره...)',
  'postDiscription': 'تشریح...',
  'optionalEmail': 'ایمیل آدرس (اختیاری)',

  'whatPost': 'در باره چه می خواهید بنویسید؟',
  'textForGeneralPost': 'مثلاً در باره حوادث عادی از محل بود و باش خود.',
  'textForAdvertPost': 'مثلاً در باره خرید، فروش و یا به کراه دادن چیزی.',
  'textForEmergencyPost': 'مثلاً ضرورت به خون، راه بندان، و حوادث امنیتی.',
  'textForLostPost': 'مثلاً چیزی یا شخصی مفقود ګردیده.',
  'textForFoundPost': 'مثلاً چیزی یا شخصی دریافت ګردیده.',
  'typeOfDeal': 'نوع معامله',
  'sell': 'فروشی',
  'rent': 'کرایی',
  'buy': 'خرید',
  'needPro': 'خدمات مسلکی',

  'price': 'قیمت(مثلاً ۳۰۰ افغانی)',
  'free': 'رایګان',
  'location': 'انتخاب موقعیت(اجباری)!',
  'emptyForm': 'فورم خالی!',
  'fillOutRequiredSections':
      'لطفا فورم را خانه پری نمائید. انتخاب موقعیت، عنوان و تشریح اجباری است.',

  ////////// Error messages ///////////////////////

  'invalidEmail':
      'ایمیل درست نیست، ایمیل درست وارد نمائید.  مثلاً ahmad@gmail.com',
  'wrongPassword': 'پسورد درست نیست، دوباره کوشش نمائید.',
  'weakPassword': 'این پسورد کوتاه و ضعیف است، حد اقل باید ۸ کرکتر باشد',
  'inUseEmail': 'این ایمیل قبلاً ثبت شده، با ایمیل دیګر راجستر شوید.',
  'userNotFound': ' کاربر موجود نیست، اګر حساب ندارید اول حساب بسازید.',
  'loginFailed': 'ورود به برنامه ناکام شد، دوباره کوشش نمائید.',
  'registrationFailed': 'ثبت نام موفق نه بود، دوباره کوشش نمائید.',
  'enter': ' وارد نمائید!',

  /////////////// Error Dialog ///////////////////

  'errorDialogTitle': 'مشکلی وجود دارد!',
  'ok': 'درست است',
  'alertDialogTitle': 'با معذرت',
  'underConstruction':
      'روی این بخش کار جریان دارد و به زودی در خدمت شما خواهد بود.',

  ///////////////////////// Settings ///////////////////////////
  'changeAppLanguage': 'زبان اپلیکشن را تغیر دهید!',

  ///////// Add Post Bottom Bar ///////////////////
  'addPhotoVideo': 'تصویر/ ویدیو',

  'select6Images': 'تا ۶ تصویر برګزینید!',
  '6ImagesSelected': '۶ تصویر پوره شد.',
  'wait': 'منتظر باشید لطفاً...',
  'noContent': 'چیزی موجود نیست.',
  'cancel': 'انصراف',

  ////////////// Post options bottom sheet ///////////////
  'savePost': 'نوشته را برای خود نشانی نمائید.',
  'savePostSubText': 'نوشته را برای بازدید برای خود ثبت نمائید.',
  'editPost': 'نوشته را اصلاح نمائید.',
  'editPostSubText': 'نوشته از خودتان است، اشتباه دارد و می خواهید اصلاح شود.',
  'hidePost': 'نوشته را پنهان نمائید.',
  'hidePostSubText': 'نوشته خوش شما نمی آید می خواهید از نظر تان پنهان شود.',
  'reportPost': 'نوشته را راپوردهی کنید.',
  'reportPostSubText': 'نوشته مشکلی دارد و می خواهید ما آنرا حذف نمائیم.',
  'deletePost': 'نوشته را حذف نمائید.',
  'deletePostSubText': 'نوشته از خودتان است و می خواهید حذف شود.',

  ///////// Search //////////////////

  'search': 'جستجو...',
  'myPosts': 'نوشته های من',
  'myFavorites': 'نشانی شده',

  /////////// Services /////////////////

  'health': 'صحی',
  'education': 'تعلیمی و تحصیلی',
  'painting': 'رنګمالی',
  'construction': 'ساختمانی',
  'carpenter': 'نجاری',
  'electrician': 'برق و لین دوانی',
  'mechanic': 'موتر و مستری',
  'cleaning': 'صفایی',
  'plumber': 'نلدوانی تمیرات',
  'laundry': 'کالا شویی',
  'computer': 'کامپیوتر و موبایل',
  'transportation': 'ترانسپورتی',
  'legal': 'حقوقی و قضایی',
  'decoration': 'دیزاین و دیکور',
  'cosmetics': 'آرایش و سلمانی',
};
