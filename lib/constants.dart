import 'package:flutter/material.dart';
import 'dart:io' show Platform;

const Map<String, Map<String, String>> SEMS = <String, Map<String, String>>{
  'الأولى': {
    '(شرح) أصول المحاسبة المالية':
        'https://i.im.ge/2022/08/22/OhhFDC.1-Accounting-A.jpg',
    '(مراجعة) أصول المحاسبة المالية':
        'https://i.im.ge/2022/08/22/OhhlgD.1-Accounting-B.jpg',
    '(شرح) أصول إدارة الأعمال':
        'https://i.im.ge/2022/08/22/OhhdN1.1-Management-A.jpg',
    '(مراجعة) أصول إدارة الأعمال':
        'https://i.im.ge/2022/08/22/OhhqVf.1-Management-B.jpg',
    '(شرح) مبادئ الاقتصاد الجزئي':
        'https://i.im.ge/2022/08/22/Ohhre4.1-Micro-A.jpg',
    '(مراجعة) مبادئ الاقتصاد الجزئي':
        'https://i.im.ge/2022/08/22/OhhX0Y.1-Micro-B.jpg',
    '(شرح) اقتصاديات الموارد والتطور الاقتصادي':
        'https://i.im.ge/2022/08/22/OhhOEq.1-Resources-A.jpg',
    '(مراجعة) اقتصاديات الموارد والتطور الاقتصادي':
        'https://i.im.ge/2022/08/22/OhhSSP.1-Resources-B.jpg',
  },
  'الثانية': {
    '(شرح) محاسبة شركات (2)':
        'https://i.im.ge/2022/08/22/Ohh75r.2-Corporation-A.jpg',
    '(مراجعة) محاسبة شركات (2)':
        'https://i.im.ge/2022/08/22/Ohharm.2-Corporation-B.jpg',
    '(شرح) ادارة انتاج': 'https://i.im.ge/2022/08/22/OhhLM0.2-Operation-A.jpg',
    '(مراجعة) ادارة انتاج':
        'https://i.im.ge/2022/08/22/OhhUIT.2-Operation-B.jpg',
    '(شرح) اقتصاد تحليلي':
        'https://i.im.ge/2022/08/22/Ohh5SG.2-Analytical-A.jpg',
    '(مراجعة) اقتصاد تحليلي':
        'https://i.im.ge/2022/08/22/OhhhEc.2-Analytical-B.jpg',
    '(شرح) مبادئ التامين':
        'https://i.im.ge/2022/08/22/Ohhjfa.2-Insurance-A.jpg',
    '(مراجعة) مبادئ التامين':
        'https://i.im.ge/2022/08/22/Ohh9Nx.2-Insurance-B.jpg',
    '(شرح) ادارة الاحتياجات':
        'https://i.im.ge/2022/08/22/OhhN8S.2-Supply-A.jpg',
    '(مراجعة) ادارة الاحتياجات':
        'https://i.im.ge/2022/08/22/OhhtMz.2-Supply-B.jpg',
  },
  'الثالثة': {
    '(شرح) اصول مراجعة': 'https://i.im.ge/2022/08/22/OhhAxF.3-Auditing-A.jpg',
    '(مراجعة) اصول مراجعة':
        'https://i.im.ge/2022/08/22/OhhyI6.3-Auditing-B.jpg',
    '(شرح) محاسبة تكاليف (1)': 'https://i.im.ge/2022/08/22/OhhCJK.3-Cost-A.jpg',
    '(مراجعة) محاسبة تكاليف (1)':
        'https://i.im.ge/2022/08/22/Ohhxd9.3-Cost-B.jpg',
    '(شرح) تطبيقات محاسبية على الحاسب':
        'https://i.im.ge/2022/08/22/Ohhcuh.3-Excel-A.jpg',
    '(مراجعة) تطبيقات محاسبية على الحاسب':
        'https://i.im.ge/2022/08/22/Ohhg9M.3-Excel-B.jpg',
    '(شرح) ادارة عامة ومحلية':
        'https://i.im.ge/2022/08/22/Ohh88Y.3-Public-A.jpg',
    '(مراجعة) ادارة عامة ومحلية':
        'https://i.im.ge/2022/08/22/OhhWQD.3-Public-B.jpg',
    '(شرح) اقتصاديات التجارة الدولية':
        'https://i.im.ge/2022/08/22/OhhZI4.3-IT-A.jpg',
    '(مراجعة) اقتصاديات التجارة الدولية':
        'https://i.im.ge/2022/08/22/OhhVnq.3-IT-B.jpg',
  },
  'الرابعة': {
    '(شرح) مراجعة متقدمة': 'https://i.im.ge/2022/08/22/Ohhkdp.4-Audit-A.jpg',
    '(مراجعة) مراجعة متقدمة': 'https://i.im.ge/2022/08/22/OhhzPP.4-Audit-B.jpg',
    '(شرح) ادارة مالية': 'https://i.im.ge/2022/08/22/OhhHk1.4-Financial-A.jpg',
    '(مراجعة) ادارة مالية':
        'https://i.im.ge/2022/08/22/Ohhvuf.4-Financial-B.jpg',
    '(شرح) نظم تكاليف': 'https://i.im.ge/2022/08/22/OhhJ9m.4-Costing-A.jpg',
    '(مراجعة) نظم تكاليف': 'https://i.im.ge/2022/08/22/OhhnRr.4-Costing-B.jpg',
    '(شرح) اقتصاديات التنمية والتخطيط':
        'https://i.im.ge/2022/08/22/OhioPG.4-Development-A.jpg',
    '(مراجعة) اقتصاديات التنمية والتخطيط':
        'https://i.im.ge/2022/08/22/OhiXkx.4-Development-B.jpg',
    '(شرح) نظم المعلومات الادارية':
        'https://i.im.ge/2022/08/22/Ohiu9J.4-MIS-A.jpg',
    '(مراجعة) نظم المعلومات الادارية':
        'https://i.im.ge/2022/08/22/OhirFa.4-MIS-B.jpg',
    '(شرح) بحوث العمليات في المحاسبة':
        'https://i.im.ge/2022/08/22/OhiFRy.4-OR-A.jpg',
    '(مراجعة) بحوث العمليات في المحاسبة':
        'https://i.im.ge/2022/08/22/Ohi2Lz.4-OR-B.jpg',
    '(شرح) مواد قسم إدارة':
        'https://i.im.ge/2022/08/22/Ohid4F.4-Management-A.jpg',
    '(مراجعة) مواد قسم إدارة':
        'https://i.im.ge/2022/08/22/OhiS36.4-Management-B.jpg',
  },
};

const Map<String, Map<String, String>> SEMS2 = <String, Map<String, String>>{
  'الأولى': {
    '(شرح) محاسبة شركات (1) ':
        'https://i.im.ge/2022/08/22/OhCl7x.1-Partnership-A.jpg',
    '(مراجعة) محاسبة شركات (1) ':
        'https://i.im.ge/2022/08/22/OhCQic.1-Partnership-B.jpg',
    '(شرح) مبادئ تسويق': 'https://i.im.ge/2022/08/22/OhCoGG.1-Marketing-A.jpg',
    '(مراجعة) مبادئ تسويق':
        'https://i.im.ge/2022/08/22/OhCMlT.1-Marketing-B.jpg',
    '(شرح) سلوك تنظيمي': 'https://i.im.ge/2022/08/22/OhCTcL.1-OB-A.jpg',
    '(مراجعة) سلوك تنظيمي': 'https://i.im.ge/2022/08/22/OhCmgq.1-OB-B.jpg',
    '(شرح) مبادئ إدارة الخطر': 'https://i.im.ge/2022/08/22/OhCREx.1-Risk-A.jpg',
    '(مراجعة) مبادئ إدارة الخطر':
        'https://i.im.ge/2022/08/22/OhCbgc.1-Risk-B.jpg',
    '(شرح) مبادئ اقتصاد كلي':
        'https://i.im.ge/2022/08/22/OhCWJa.1-Macroeconomics-A.jpg',
    '(مراجعة) مبادئ اقتصاد كلي':
        'https://i.im.ge/2022/08/22/OhCgML.1-Macroeconomics-B.jpg',
    '(شرح) مصطلحات تجارية':
        'https://i.im.ge/2022/08/22/OhCH56.1-Terminologies-A.jpg',
    '(مراجعة) مصطلحات تجارية':
        'https://i.im.ge/2022/08/22/OhCJMK.1-Terminologies-B.jpg',
  },
  'الثانية': {
    '(شرح) محاسبة متخصصة':
        'https://i.im.ge/2022/08/22/OhC4xX.2-Specialized-A.jpg',
    '(مراجعة) محاسبة متخصصة':
        'https://i.im.ge/2022/08/22/OhCnI9.2-Specialized-B.jpg',
    '(شرح) اقصاديات النقود والبنوك':
        'https://i.im.ge/2022/08/22/OhEMPM.2-Money-and-Banking-A.jpg',
    '(مراجعة) اقصاديات النقود والبنوك':
        'https://i.im.ge/2022/08/22/OhEouD.2-Money-and-Banking-B.jpg',
    '(شرح) إدارة المواد البشرية':
        'https://i.im.ge/2022/08/22/OhEFIp.2-HR-A.jpg',
    '(مراجعة) إدارة المواد البشرية':
        'https://i.im.ge/2022/08/22/OhE1n1.2-HR-B.jpg',
    '(شرح) مصطلحات تجارية':
        'https://i.im.ge/2022/08/22/OhEdPm.2-Terminologies-A.jpg',
    '(مراجعة) مصطلحات تجارية':
        'https://i.im.ge/2022/08/22/OhESdf.2-Terminologies-B.jpg',
  },
  'الثالثة': {
    '(شرح) إدارة تفاوض':
        'https://i.im.ge/2022/08/22/OhEqkr.3-Negotiation-A.jpg',
    '(مراجعة) إدارة تفاوض':
        'https://i.im.ge/2022/08/22/OhEDRT.3-Negotiation-B.jpg',
    '(شرح) مالية عامة':
        'https://i.im.ge/2022/08/22/OhEhxG.3-Public-Finance-A.jpg',
    '(مراجعة) مالية عامة':
        'https://i.im.ge/2022/08/22/OhEULL.3-Public-Finance-B.jpg',
    '(شرح) المحاسبة الإدارية':
        'https://i.im.ge/2022/08/22/OhEinx.3-Managerial-Accounting-A.jpg',
    '(مراجعة) المحاسبة الإدارية':
        'https://i.im.ge/2022/08/22/OhE9PJ.3-Managerial-Accounting-B.jpg',
    '(شرح) محاسبة حكومية و دولية':
        'https://i.im.ge/2022/08/22/OhEwFS.3-Governmental-Accounting-A.jpg',
    '(مراجعة) محاسبة حكومية و دولية':
        'https://i.im.ge/2022/08/22/OhE69z.3-Governmental-Accounting-B.jpg',
    '(شرح) محاسبة تكاليف (2)':
        'https://i.im.ge/2022/08/22/OhEtTF.3-Cost-Accounting-A.jpg',
    '(مراجعة) محاسبة تكاليف (2)':
        'https://i.im.ge/2022/08/22/OhENR6.3-Cost-Accounting-B.jpg',
  },
  'الرابعة': {
    '(شرح) محاسبة منشات مالية':
        'https://i.im.ge/2022/08/22/OhEyLK.4-Institutional-Accounting-A.jpg',
    '(مراجعة) محاسبة منشات مالية':
        'https://i.im.ge/2022/08/22/OhEC4X.4-Institutional-Accounting-B.jpg',
    '(شرح) تخطيط إستراتيجي':
        'https://i.im.ge/2022/08/22/OhEYzM.4-Strategic-Planning-A.jpg',
    '(مراجعة) تخطيط إستراتيجي':
        'https://i.im.ge/2022/08/22/OhE3th.4-Strategic-Planning-B.jpg',
    '(شرح) قضايا اقتصادية معاصرة':
        'https://i.im.ge/2022/08/22/OhEcFY.4-Economic-Issues-A.jpg',
    '(مراجعة) قضايا اقتصادية معاصرة':
        'https://i.im.ge/2022/08/22/OhEgjD.4-Economic-Issues-B.jpg',
    '(شرح) محاسبة ضريبية': 'https://i.im.ge/2022/08/22/OhEZUq.4-Tax-A.jpg',
    '(مراجعة) محاسبة ضريبية': 'https://i.im.ge/2022/08/22/OhEV4P.4-Tax-B.jpg',
    '(شرح) دراسة جدوى': 'https://i.im.ge/2022/08/22/OhEztf.4-Feasibility-A.jpg',
    '(مراجعة) دراسة جدوى':
        'https://i.im.ge/2022/08/22/OhEks1.4-Feasibility-B.jpg',
    '(شرح) نظم معلومات محاسبية':
        'https://i.im.ge/2022/08/22/OhEHzm.4-AIS-A.jpg',
    '(مراجعة) نظم معلومات محاسبية':
        'https://i.im.ge/2022/08/22/OhEvOr.4-AIS-B.jpg',
    '(شرح) (قسم إدارة) مواد ':
        'https://i.im.ge/2022/08/22/OhEnW0.4-Management-A.jpg',
    '(مراجعة) (قسم إدارة) مواد ':
        'https://i.im.ge/2022/08/22/OhEJjW.4-Management-B.jpg',
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
