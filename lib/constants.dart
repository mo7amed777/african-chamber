import 'package:flutter/material.dart';
import 'dart:io' show Platform;

const Map<String, Map<String, String>> SEMS = <String, Map<String, String>>{
  'الأولى': {
    'أصول المحاسبة المالية':
        'https://www.almrsal.com/wp-content/uploads/2017/09/%D9%83%D8%AA%D8%A8-%D8%A7%D9%84%D8%AA%D8%B3%D9%88%D9%8A%D9%82.jpg',
    'أصول إدارة الأعمال':
        'https://modo3.com/thumbs/fit630x300/254038/1629875947/%D8%AA%D8%B9%D8%B1%D9%8A%D9%81_%D8%A7%D9%84%D8%A7%D9%82%D8%AA%D8%B5%D8%A7%D8%AF_%D8%A7%D9%84%D9%83%D9%84%D9%8A.jpg',
    'مبادئ الاقتصاد الجزئي':
        'https://i2.wp.com/www.thechamberofbusiness.com/wp-content/uploads/2020/05/Organizational-Behavior.jpg?fit=804%2C400&ssl=1',
    'اقتصاديات الموارد والتطور الاقتصادي':
        'https://i.ytimg.com/vi/XvjvJeFagko/maxresdefault.jpg',
  },
  'الثانية': {
    'محاسبة شركات (2)':
        'https://www.techfunnel.com/wp-content/uploads/2019/08/15-Ways-Digital-Banking-Drives-Revenue-Growth-1.png',
    'ادارة انتاج':
        'https://fjwp.s3.amazonaws.com/blog/wp-content/uploads/2019/11/29144739/HR-career.png',
    'اقتصاد تحليلي':
        'https://www.almaal.org/wp-content/uploads/2021/05/%D8%A3%D9%87%D9%85-%D8%A7%D9%84%D9%85%D8%B5%D8%B7%D9%84%D8%AD%D8%A7%D8%AA-%D8%A7%D9%84%D8%AA%D8%AC%D8%A7%D8%B1%D9%8A%D8%A9.jpg',
    'مبادئ التامين':
        'http://fortunetsp.com/services/wp-content/uploads/2019/03/specialized-acciunting.jpg',
    'ادارة الاحتياجات':
        'http://fortunetsp.com/services/wp-content/uploads/2019/03/specialized-acciunting.jpg',
  },
  'الثالثة': {
    'اصول مراجعة':
        'https://cloudinary.hbs.edu/hbsit/image/upload/s--mS7H2QFE--/f_auto,c_fill,h_375,w_750,/v20200101/32C8D93D513DF95DE7E5A2532E55720E.jpg',
    'محاسبة تكاليف (1)':
        'https://businessyield.com/wp-content/uploads/2020/11/images-13.jpeg',
    'تطبيقات محاسبية على الحاسب':
        'https://thumbs.dreamstime.com/b/conceptual-hand-written-text-showing-managerial-accounting-conceptual-hand-written-text-showing-managerial-accounting-168464725.jpg',
    'ادارة عامة ومحلية':
        'https://www.topaccountingdegrees.org/wp-content/uploads/2015/12/international-tax-consulting.jpg',
    'اقتصاديات التجارة الدولية':
        'https://qsstudy.com/wp-content/uploads/2019/01/Cost-Accounting-3.jpg',
  },
  'الرابعة': {
    'مراجعة متقدمة':
        'https://sdaho.org/wp-content/uploads/2020/07/strategic-planning.png',
    'ادارة مالية':
        'https://blogs.iadb.org/ideas-matter/wp-content/uploads/sites/12/2017/06/shutterstock_102687368.jpg',
    'نظم تكاليف':
        'https://capitalcampaignmasters.com/wpsys/wp-content/uploads/2019/03/feasibility-study-common-misconceptions.jpg',
    'اقتصاديات التنمية والتخطيط':
        'https://www.meritglobaltraining.com/images/best-marketing-research-professional-course.jpg',
    'نظم المعلومات الادارية':
        'https://www.managementstudyhq.com/wp-content/uploads/2018/11/Organization-Management.jpg',
    'بحوث العمليات في المحاسبة':
        'https://journolink-static.s3.eu-west-1.amazonaws.com/assets/content/MGgUHR8JVZfWjoqFjJLrpaUQQndhgU5wxUAlShRO.png',
    'مواد قسم إدارة':
        'https://www.marketing2business.com/wp-content/uploads/2019/06/Bank-Accounting1.png',
  },
};

const Map<String, Map<String, String>> SEMS2 = <String, Map<String, String>>{
  'الأولى': {
    'Partnership accounting  محاسبة شركات (1) ':
        'https://i.ytimg.com/vi/XvjvJeFagko/maxresdefault.jpg',
    'Marketing principles  مبادئ تسويق':
        'https://www.almrsal.com/wp-content/uploads/2017/09/%D9%83%D8%AA%D8%A8-%D8%A7%D9%84%D8%AA%D8%B3%D9%88%D9%8A%D9%82.jpg',
    'Organizational behavior  سلوك تنظيمي':
        'https://i2.wp.com/www.thechamberofbusiness.com/wp-content/uploads/2020/05/Organizational-Behavior.jpg?fit=804%2C400&ssl=1',
    'Risk management  مبادئ إدارة الخطر':
        'https://www.sscsrl.com/wp-content/uploads/2017/07/risk-management.jpg',
    'Macroeconomics  مبادئ اقتصاد كلي':
        'https://modo3.com/thumbs/fit630x300/254038/1629875947/%D8%AA%D8%B9%D8%B1%D9%8A%D9%81_%D8%A7%D9%84%D8%A7%D9%82%D8%AA%D8%B5%D8%A7%D8%AF_%D8%A7%D9%84%D9%83%D9%84%D9%8A.jpg',
    'Terminologies  مصطلحات تجارية':
        'https://www.almaal.org/wp-content/uploads/2021/05/%D8%A3%D9%87%D9%85-%D8%A7%D9%84%D9%85%D8%B5%D8%B7%D9%84%D8%AD%D8%A7%D8%AA-%D8%A7%D9%84%D8%AA%D8%AC%D8%A7%D8%B1%D9%8A%D8%A9.jpg',
  },
  'الثانية': {
    'Specialized accounting  محاسبة متخصصة':
        'http://fortunetsp.com/services/wp-content/uploads/2019/03/specialized-acciunting.jpg',
    'Money and banking  اقصاديات النقود والبنوك':
        'https://www.techfunnel.com/wp-content/uploads/2019/08/15-Ways-Digital-Banking-Drives-Revenue-Growth-1.png',
    'Human resources management  إدارة المواد البشرية':
        'https://fjwp.s3.amazonaws.com/blog/wp-content/uploads/2019/11/29144739/HR-career.png',
    'Terminologies  مصطلحات تجارية':
        'https://www.almaal.org/wp-content/uploads/2021/05/%D8%A3%D9%87%D9%85-%D8%A7%D9%84%D9%85%D8%B5%D8%B7%D9%84%D8%AD%D8%A7%D8%AA-%D8%A7%D9%84%D8%AA%D8%AC%D8%A7%D8%B1%D9%8A%D8%A9.jpg',
  },
  'الثالثة': {
    'Negotiation management  إدارة تفاوض':
        'https://cloudinary.hbs.edu/hbsit/image/upload/s--mS7H2QFE--/f_auto,c_fill,h_375,w_750,/v20200101/32C8D93D513DF95DE7E5A2532E55720E.jpg',
    'Public finance  مالية عامة':
        'https://businessyield.com/wp-content/uploads/2020/11/images-13.jpeg',
    'Managerial accounting  المحاسبة الإدارية':
        'https://thumbs.dreamstime.com/b/conceptual-hand-written-text-showing-managerial-accounting-conceptual-hand-written-text-showing-managerial-accounting-168464725.jpg',
    'Governmental and international accounting  محاسبة حكومية و دولية':
        'https://www.topaccountingdegrees.org/wp-content/uploads/2015/12/international-tax-consulting.jpg',
    'Cost accounting  محاسبة تكاليف (2)':
        'https://qsstudy.com/wp-content/uploads/2019/01/Cost-Accounting-3.jpg',
  },
  'الرابعة': {
    'Banking accounting  محاسبة منشات مالية':
        'https://www.marketing2business.com/wp-content/uploads/2019/06/Bank-Accounting1.png',
    'Strategic planning  تخطيط إستراتيجي':
        'https://sdaho.org/wp-content/uploads/2020/07/strategic-planning.png',
    'Recent economic issues  قضايا اقتصادية معاصرة':
        'https://blogs.iadb.org/ideas-matter/wp-content/uploads/sites/12/2017/06/shutterstock_102687368.jpg',
    'Tax accounting  محاسبة ضريبية':
        'https://e7.pngegg.com/pngimages/849/211/png-clipart-tax-illustration-goods-and-services-tax-accounting-payment-calculate-the-tax-text-service.png',
    'Feasibility studies  دراسة جدوى':
        'https://capitalcampaignmasters.com/wpsys/wp-content/uploads/2019/03/feasibility-study-common-misconceptions.jpg',
    'Accounting Information System  نظم معلومات محاسبية':
        'https://cdn.educba.com/academy/wp-content/uploads/2020/07/psd-9-9-5-4.jpg',
    '(قسم إدارة) مواد ':
        'https://www.meritglobaltraining.com/images/best-marketing-research-professional-course.jpg',
  },
};
Map<String, Map<String, String>> SEMs = {};

final PRIMARYCOLOR = Colors.blue[400];
const SECONDARYCOLOR = Colors.white;

final bannerAdUnitId = Platform.isAndroid
    ? 'ca-app-pub-4096410892355332/6764687502'
    : 'ca-app-pub-4096410892355332/6169080696';
final interstitialAdUnitId = Platform.isAndroid
    ? 'ca-app-pub-4096410892355332/1199539634'
    : 'ca-app-pub-4096410892355332/7297866517';
final rewardedVideoAdUnitId = Platform.isAndroid
    ? 'ca-app-pub-4096410892355332/3208763484'
    : 'ca-app-pub-4096410892355332/8419376498';
