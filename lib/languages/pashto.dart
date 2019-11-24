import 'package:font_awesome_flutter/font_awesome_flutter.dart';

const Map pashto = {
  // Login and registration
  'login': 'ننوځئ',
  'signOut': 'وتل',
  'email': 'برېښنالیک',
  'password': 'پسورد',
  'register': 'حساب جوړ کړه!',
  'haveAnAccount': 'که حساب لرې،',
  'doNotHaveAnAccount': 'که حساب نه لرې، ',
  'phone': ' تیلفون شمېره (اختیاری)',
  'name': 'کارېدونکی نوم',

  'signinWithFacebook': 'فیسبوک سره ننوځه',
  'signinWithGoogle': 'ګوګل  سره  ننوځه ',
  'registerWithFacebook': 'فیسبوکي ثبت نام',
  'registerWithGoogle': 'ګوګل  ثبت  نام ',

  'more': 'نور...',

  // ToolBar and Main Screen
  'home': 'کور',
  'market': 'بازار',
  'messages': 'پیغامونه',
  'me': 'زه',
  'services': 'خدمات',

  // post/advert actions buttons

  'text': 'پیغام',
  'call': 'زنګ',
  'comment': 'تبصره',
  'hide': 'پټول',
  'like': 'خوښول',

  //////////////////// post /////////////////////////////////////

  'advert': 'اعلان',
  'general': 'عمومی',
  'lost': 'مفقودی',
  'found': 'پیدا شوی',
  'emergency': 'عاجل',

  'singleComment': 'تبصره',
  'multiComments': 'تبصرې',
  'addComment': 'تبصره...',

  'addNewPost': 'نوی پوست ولیکه!',
  'jobs': 'وظیفه',
  'send': 'لېږل',
  'typeOfTransaction': 'د معاملې ډول',
  'postTitle': 'عنوان...',
  'advertPostTitle':
      'عنوان(اجباری): (مثلاً موټر د خرڅلاو لپاره، کور د کراه لپاره او نور...)',
  'advertPostDiscription':
      'تشریح(اجباری): (مثلا رنګ، کال، مستعمل، نوی او نور...)',
  'postDiscription': 'تشریح...',
  'optionalEmail': 'برېښنالیک (اختیاری)',

  'whatPost': 'د څه شي په اړه غواړی ولیکی؟',
  'textForGeneralPost': 'مثلاً د خپل محل د عادی حوادثو او مسایلو په اړه.',
  'textForAdvertPost': 'مثلاً د کوم شي د اخیستو، کراه، او یا خرڅولو په اړه.',
  'textForEmergencyPost': 'مثلاً د وینې ضرورت، لار بنده ده او عاجل حوادث.',
  'textForLostPost': 'مثلاً کوم شی او یا شخص ورک دی.',
  'textForFoundPost': 'مثلاً کوم لادرکه شی او یا شخص پیدا شوی دی.',

  'typeOfDeal': 'د معاملې ډول',
  'sell': 'پلورل',
  'rent': 'کرایی',
  'buy': 'اخیستل',
  'needPro': 'مسلکي خدمتونه',

  'price': 'قیمت(مثلاً ۳۰۰ افغانی)',
  'free': 'وړیا',
  'location': 'ځای انتخاب کړئ (اجباری)!',

  'emptyForm': 'تش فورم!',
  'fillOutRequiredSections':
      'لطفاً ضروری معلومات سم ولیکئ. د ځای، عنوان او تشریحاتو برخه اجباري ده.',

  ////////// Sign in/up error messages ///////////////////////

  'invalidEmail':
      'ایمیل سم نه دی، لطفاً سم ایمیل و کاروئ.  مثلاً ahmad@gmail.com',
  'wrongPassword': 'پسورد سم نه دی، بیا هڅه وکړئ.',
  'weakPassword': 'پسورد لنډ او کمزوری دی، پسورد باید کم تر کمه ۸ کرکتره وي.',
  'inUseEmail': 'دا برېښنالیک مخکې ثبت شوی دی، لطفاً بل برېښنالیک و کاروئ.',
  'userNotFound':
      ' په دې نوم حساب نه شته، که حساب نه لرئ لطفاً اول ثبت نام وکړئ. ',
  'loginFailed': 'پروګرام ته ننوتل ناکام شول، بیا هڅه وکړئ.',
  'registrationFailed': 'ثبت نام و نه شو، لطفاً له سره هڅه وکړئ.',

  'enter': ' ولیکئ!',

  /////////////// Error Dialog ///////////////////

  'errorDialogTitle': 'ستونزه',
  'ok': 'سمه ده',
  'alertDialogTitle': 'وبښئ',
  'underConstruction':
      'دا برخه تر کار لاندې ده او ژر به ستاسې چوپړ ته آماده شي.',

  ///////////////////////// Settings ///////////////////////////
  'changeAppLanguage': 'د اپلیکشن ژبه واړوئ!',

  ///////// Add Post Bottom Bar ///////////////////
  'addPhotoVideo': 'انځور/ ویډیو',

  'select6Images': '۶ انځوره پورته کوی شی.',
  '6ImagesSelected': '۶ پوره شول',
  'wait': 'منتظر اوسی لطفاً...',
  'noContent': 'څه نشته.',
  'cancel': 'انصراف',

  ////////////// Post options bottom sheet ///////////////
  'savePost': 'لیکنه نشاني کړی.',
  'savePostSubText': 'لیکنه ځان ته نشاني کړی تر څو یې بیا ولیدای شی.',
  'editPost': 'لیکنه اصلاح کړی.',
  'editPostSubText': 'لیکنه ستاسې خپله ده، ستونزه لري غواړی سمه یې کړی.',
  'hidePost': 'لیکنه پټه کړی.',
  'hidePostSubText': 'لیکنه مو نه خوښیږي غواړی له نظره مو لرې شي.',
  'reportPost': 'لیکنه رپوټ کړی.',
  'reportPostSubText': 'لیکنه ستونزه لري او غواړی موږ یې ایسته کړو.',
  'deletePost': 'لیکنه پاکه کړی.',
  'deletePostSubText': 'لیکنه ستاسې خپله ده او غواړی ایسته یې کړی.',

  ///////// Search //////////////////

  'search': 'پلټنه...',
  'myPosts': 'زما لیکنې',
  'myFavorites': 'نشاني شوې',

  /////////// Services /////////////////

  'health': 'روغتیایي',
  'education': 'تعلیمي او تحصیلي',
  'painting': 'رنګمالي',
  'construction': 'ساختماني',
  'carpenter': 'نجاري',
  'electrician': 'برق او لین تېرول',
  'mechanic': 'موتر او مستري',
  'cleaning': 'صفايي',
  'plumber': 'د تعمیراتو نل دواني',
  'laundry': 'کالي مېنځل',
  'computer': 'کامپیوتر او موبایل',
  'transportation': 'ترانسپورتي',
  'legal': 'حقوقي او قضایي',
  'decoration': 'دیزاین او دیکور',
  'cosmetics': 'سینګار او سلماني',
};
