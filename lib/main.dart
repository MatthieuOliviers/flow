import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/cupertino.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';


import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'package:url_launcher/url_launcher.dart';

import 'package:procaryote_utils/utils/firebase_options.dart';

import 'package:procaryote_utils/utils/login_page.dart';
import 'package:procaryote_utils/utils/profile_page.dart';


import 'package:procaryote_utils/utils/provider/locale_provider.dart';
import 'package:procaryote_utils/utils/widget/language_picker_widget.dart';
import 'package:procaryote_utils/utils/translate.dart';

import 'package:procaryote_utils/utils/widget/application_list_widget.dart';


import 'package:procaryote_utils/utils/widget/drawer_menu.dart';


import 'package:procaryote_utils/utils/widget/bottom_menu_Procaryote.dart';

import 'package:procaryote_utils/utils/widget/account_management.dart';

import 'package:procaryote_utils/utils/l10n/l10n.dart';

import 'package:procaryote_utils/utils/theme.dart';


import 'package:procaryote_utils/utils/pages/main_application.dart';
//import 'package:procaryote_utils/utils/pages/application_list_page.dart';

import 'package:procaryote_utils/utils/pages/about_consulting_page.dart';

import 'package:procaryote_utils/utils/pages/privacy_page.dart';
import 'package:procaryote_utils/utils/pages/terms_page.dart';
import 'package:procaryote_utils/utils/pages/contact_page.dart';



String applicationName = "Flow";

String accessToPlanner = "All users";

////////////////////////////////////////////////////////////////////////
/// Initialization of an instance of Cloud Firestore
////////////////////////////////////////////////////////////////////////
FirebaseFirestore db = FirebaseFirestore.instance;

var collectionUserPreferenceGeneral = db.collection('user_preference_general');


final FirebaseAuth auth = FirebaseAuth.instance;
User? currentUser = auth.currentUser;
final currentUserUid = currentUser!.uid;
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////
/////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////
//  String myurl = Uri.base.toString(); //get complete url
//String path = Uri.base;
String fullPath = Uri.base.path;
List<String> listPathSegments = Uri.base.pathSegments;
String path = fullPath.substring(fullPath.lastIndexOf('/') + 1);
String caregiversSearchKeywords = "";
//String path = listPathSegments[listPathSegments.length - 1];
//String path = listPathSegments.last;
//String path = Uri.base.pathSegments.last;
//final caregiver = Uri.parse(settings.name);
//final bookid = settingsUri.pathSegments.elementAt(1);
//  String path = Uri.base.path;
//  String caregiver = Uri.base.queryParameters["caregiver"]; //get parameter with attribute "caregiver"
//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////
final caregiversInMyPatientsCollection = FirebaseFirestore.instance
    .collection('my_patients')
    .withConverter<CareGiverInMyPatientData>(
      fromFirestore: (snapshots, _) =>
          CareGiverInMyPatientData.fromJson(snapshots.data()!),
      toFirestore: (caregiver, _) => caregiver.toJson(),
    );

//////////////////////////////////////////////////////////////////////////
enum CareGiverInMyPatientsQuery {
  AllMyRequests,
}

////////////////////////////////////////////////////////////////////////
extension on Query<CareGiverInMyPatientData> {
  Query<CareGiverInMyPatientData> queryBy(CareGiverInMyPatientsQuery query) {
    switch (query) {
      case CareGiverInMyPatientsQuery.AllMyRequests:
        return where(
          'patientUserID',
          isEqualTo: currentUserUid,
        );
    }
  }
}

//////////////////////////////////////////////////////////////////////////
final caregiversInCareGiverCollection = FirebaseFirestore.instance
    .collection('users')
//cg>u    .collection('care_giver')
    .withConverter<CareGiverData>(
      fromFirestore: (snapshots, _) =>
          CareGiverData.fromJson(snapshots.data()!),
      toFirestore: (caregiver, _) => caregiver.toJson(),
    );

//////////////////////////////////////////////////////////////////////////
enum CareGiverQuery {
  caregiversSearchBoxInPathFilter,
  firstNameInPathFilter,
  lastNameInPathFilter,
  fullNameInPathFilter,
  inamiInPathFilter,
}

////////////////////////////////////////////////////////////////////////
extension on Query<CareGiverData> {
  Query<CareGiverData> queryBy(CareGiverQuery query) {
    switch (query) {
      case CareGiverQuery.caregiversSearchBoxInPathFilter:
        return where(
//          'status',
//          isEqualTo: "Active",
//        )
//            .where(
          'lastName',
          isEqualTo: caregiversSearchKeywords,
//          isGreaterThanOrEqualTo: caregiversSearchKeywords,
//          isLessThan: caregiversSearchKeywords + "z",
        )
            .where('inami', isGreaterThan: "10000000")
            .where('status', isEqualTo: "Active")
            .limit(10);

      case CareGiverQuery.firstNameInPathFilter:
        return where('firstName', isEqualTo: path)
            .where('inami', isGreaterThan: "10000000")
//cg>u        return where('firstname', isEqualTo: path)
            .where('status', isEqualTo: "Active");
//cg>u            .where('status_str', isEqualTo: "Active");

      case CareGiverQuery.lastNameInPathFilter:
        return where('lastName', isEqualTo: path)
            .where('inami', isGreaterThan: "10000000")

//cg>u        return where('firstname', isEqualTo: path)
            .where('status', isEqualTo: "Active");
//cg>u            .where('status_str', isEqualTo: "Active");

      case CareGiverQuery.fullNameInPathFilter:
//        return where('Fullname', isEqualTo: "patriciacarlier")
//        return where('Fullname', isEqualTo: "aminedahmane")
//        return where('Firstname', isEqualTo: "Patricia")
        return where('fullName', isEqualTo: path)
            .where('inami', isGreaterThan: "10000000")
            .where('status', isEqualTo: "Active");
//cg>u            .where('status_str', isEqualTo: "Active");

      case CareGiverQuery.inamiInPathFilter:
        return where("inami", isEqualTo: path)
            .where('inami', isGreaterThan: "10000000")
            .where('status', isEqualTo: "Active");
//cg>u            .where('status_str', isEqualTo: "Active");
//            .limit(20);
    }
  }
}

//////////////////////////////////////////////////////////////////////////
final caregiversInConsultationRequestsCollection = FirebaseFirestore.instance
    .collection('consultation_requests')
    .withConverter<CareGiverDataFromConsultationRequests>(
      fromFirestore: (snapshots, _) =>
          CareGiverDataFromConsultationRequests.fromJson(snapshots.data()!),
      toFirestore: (caregiver, _) => caregiver.toJson(),
    );

//////////////////////////////////////////////////////////////////////////
enum CareGiverQueryForConsultationRequestsCollection {
  alreadyMyCareGiversFilter,
  alreadySentFilter,
  alreadyAnsweredFilter,
}

////////////////////////////////////////////////////////////////////////
extension on Query<CareGiverDataFromConsultationRequests> {
  Query<CareGiverDataFromConsultationRequests> queryBy(
      CareGiverQueryForConsultationRequestsCollection query) {
//    final FirebaseAuth auth = FirebaseAuth.instance;

    switch (query) {
      case CareGiverQueryForConsultationRequestsCollection
          .alreadyMyCareGiversFilter:
        return where("status_str", whereIn: ["Answered", "Sent"])
            .where('creationUid', isEqualTo: currentUserUid);
//            .limit(20);

      case CareGiverQueryForConsultationRequestsCollection.alreadySentFilter:
        return where("status_str", isEqualTo: "Sent");
//            .limit(20);

      case CareGiverQueryForConsultationRequestsCollection
          .alreadyAnsweredFilter:
        return where("status_str", isEqualTo: "Answered");
//            .limit(20);
    }
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(flowMainApp(path: path));
}

class flowMainApp extends StatefulWidget {
  String path;

  flowMainApp({this.path = ""});

  @override
  State<flowMainApp> createState() => _flowMainAppState();
}

class _flowMainAppState extends State<flowMainApp> {
  bool _isDarkMode = false;
  bool _isCaregiverMode = false;

  void _toggleTheme(bool value) {
    setState(() {
      _isDarkMode = value;
    });
  }

  void _toggleMode(bool value) {
    setState(() {
      _isCaregiverMode = value;
    });
  }


  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
      create: (context) => LocaleProvider(),
      builder: (context, child) {
        final provider = Provider.of<LocaleProvider>(context);

        return MaterialApp(
          debugShowCheckedModeBanner: false,
            title: 'PROCARYOTE - Flow',
          theme: _isDarkMode
              ? CommonMethod().darkThemeData
              : CommonMethod().themeData,
          locale: provider.locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
/*
          home: AboutPage(
            toggleTheme: _toggleTheme,
            isDarkMode: _isDarkMode,
            toggleMode: _toggleMode,
            isCaregiverMode: _isCaregiverMode,
          ),
*/
//          home: AboutPage(applicationName),


        home: MainApplicationListApp(),
//        home: applicationListPage(),
//        home: LoginPage(),
//        home: LoginPage(applicationName: 'Flow'),
//        home: LoginPage(applicationName: applicationName),
/*
        home: flowHomePage(
              title: 'Procaryote     Flow',
              path: path,
              documentReferenceID: "",

              toggleTheme: _toggleTheme,
              isDarkMode: _isDarkMode,
              toggleMode: _toggleMode,
              isCaregiverMode: _isCaregiverMode,
        
        
        ),
*/
/*
          home: MyHomePage(
            toggleTheme: _toggleTheme,
            isDarkMode: _isDarkMode,
            toggleMode: _toggleMode,
            isCaregiverMode: _isCaregiverMode,
          ),
*/
        );
      },
      );
}

class flowHomePage extends StatefulWidget {

    final String documentReferenceID;
  final String title;
  final String path;

  final ValueChanged<bool> toggleTheme;
  final bool isDarkMode;

  final ValueChanged<bool> toggleMode;
  final bool isCaregiverMode;


//  const flowHomePage(
//    {super.key, required this.title});

 const flowHomePage(
      {Key? key,
      required this.title,
      required this.path,
      required this.documentReferenceID,
      required this.toggleTheme,
      required this.isDarkMode,
      required this.toggleMode,
      required this.isCaregiverMode})
      : super(key: key);



//  @override
//  State<flowHomePage> createState() => _flowHomePageState();

  @override
  _flowHomePageState createState() => _flowHomePageState();

}

class _flowHomePageState extends State<flowHomePage> {
  User? newLoggedUser;

  Future<void> _navigateToLoginPage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );

    if (result != null) {
      if (!mounted) return;
      setState(() async {
        newLoggedUser = result as User;

        var docSnapshotUserLanguageCode = await collectionUserPreferenceGeneral
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get();

        Map<String, dynamic>? dataUserPreference =
            docSnapshotUserLanguageCode.data();
        String languageCodeStr =
            dataUserPreference?['languageTwoLetterCoder'] ?? 'EN';

//        final locale = Locale(L10n.getLowercaseLanguageCode(languageCodeStr));
        final locale = Locale(L10n.getLowercaseLanguageCode(languageCodeStr));

        final provider = Provider.of<LocaleProvider>(context, listen: false);

        provider.setLocale(locale);
      });
    }
  }


  CareGiverInMyPatientsQuery queryOfInPatient =
      CareGiverInMyPatientsQuery.AllMyRequests;

  CareGiverQuery queryCaregiversSearchBox =
      CareGiverQuery.caregiversSearchBoxInPathFilter;
  CareGiverQuery query1a = CareGiverQuery.firstNameInPathFilter;
  CareGiverQuery query1b = CareGiverQuery.lastNameInPathFilter;
  CareGiverQuery query2 = CareGiverQuery.fullNameInPathFilter;
  CareGiverQuery query3 = CareGiverQuery.inamiInPathFilter;

  CareGiverQueryForConsultationRequestsCollection query4 =
      CareGiverQueryForConsultationRequestsCollection.alreadySentFilter;
  CareGiverQueryForConsultationRequestsCollection query5 =
      CareGiverQueryForConsultationRequestsCollection.alreadyAnsweredFilter;
  CareGiverQueryForConsultationRequestsCollection query6 =
      CareGiverQueryForConsultationRequestsCollection.alreadyMyCareGiversFilter;



  @override
  initState() {
    super.initState();

    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (mounted) {
        setState(() {
          newLoggedUser = user;
        });
      }
    });

    caregiversSearchKeywords = "";
  }

  final FirebaseAuth auth = FirebaseAuth.instance;
  User? user = FirebaseAuth.instance.currentUser;

  signOut() async {
    await auth.signOut();

    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return flowMainApp();
    }));
  }

  void runFilterFromSearch(String enteredKeyword) {
    String results = "";
    if (enteredKeyword.isEmpty) {
      results = "";
    } else {
      results = enteredKeyword;
    }

    setState(() {
      caregiversSearchKeywords = results;
    });
  }

  List<bool> toggleButtonIsSelected = [true, false];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      drawer: ProcaryoteDrawer(applicationName, widget.toggleTheme,
          widget.isDarkMode, widget.toggleMode, widget.isCaregiverMode),
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: Text(translation(context).myCaregivers),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        actions: (newLoggedUser == null)
            ? <Widget>[
                applicationListButtonWidget(applicationName,widget.isCaregiverMode),
                const SizedBox(width: 24.0),
                LanguagePickerWidget(),
                const SizedBox(width: 24.0),
                accountButtonWidget(),
                const SizedBox(width: 16.0),
              ]
            : <Widget>[
                IconButton(
                  icon: const Icon(Icons.markunread_mailbox_outlined),
                  onPressed: () {

/*
CHANGE FROM CONSULT ==> FLOW
=======================================
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const ConsultationRequestList();
                    }));
*/                  
                  
                  },
                ),
                accountButtonConnectedWidget(
                    applicationName, widget.isCaregiverMode),
                const SizedBox(width: 16.0),
//                LanguagePickerWidget(),
/*
                IconButton(
                  icon: Icon(Icons.supervised_user_circle_outlined),
//                  icon: Icon(FontAwesomeIcons.userDoctor),
                  onPressed: () async {
                    user = await Navigator.push(context,
                        MaterialPageRoute(builder: (context) => MyDoctors()));
                    if (user != null) {
                      setState(() {
                        this.user = user;
                      });
                    }
                  },
                ),
*/
/*
                PopupMenuButton(
                    icon: const Icon(Icons.account_circle_outlined),
                    itemBuilder: (BuildContext contextFiltered) {
                      return [
                        PopupMenuItem<int>(
                          value: 0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.account_circle_outlined,
                                    size: 20,
                                    color: Color.fromARGB(255, 3, 83, 94),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    translation(context).myProfile,
                                    style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  const Divider(color: Colors.black)
                                ],
                              ),
                            ],
                          ),
                        ),
                        PopupMenuItem<int>(
                          value: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.logout,
                                    size: 20,
                                    color: Color.fromARGB(255, 3, 83, 94),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    translation(context).signOut,
//                                    'Se déconnecter',
                                    style: const TextStyle(
//                                color: Colors.black54,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  const Divider(color: Colors.black)
                                ],
                              ),
                            ],
                          ),
                        ),
                      ];
                    },
                    onSelected: (value) {
                      if (value == 0) {
                        User? user = FirebaseAuth.instance.currentUser;
                        if (user != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProfilePage(user: user)),
                          );
                        }
                        ;
                      } else if (value == 1) {
                        signOut();
                      }
                    }),
                    */
              ],
      ),
      body: SingleChildScrollView(
        child: Container(
//        constraints: const BoxConstraints(maxWidth: 768),
          padding: const EdgeInsets.all(8),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 8),

              Text(
                translation(context).titre1DemandeConsultation,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16.0,
                  color: Color.fromARGB(255, 6, 137, 181),
                ),
              ),

              const SizedBox(height: 8),

              Text(
                translation(context).titre2DemandeConsultation,
                textAlign: TextAlign.center,
              ),

              Text(
                translation(context).titre3DemandeConsultation,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 24),

              Container(
                constraints: const BoxConstraints(maxWidth: 300),
                child: TextField(
                  onChanged: (value) => runFilterFromSearch(value),
                  decoration: InputDecoration(
                    labelText: translation(context).search,
                    suffixIcon: const Icon(Icons.search),
                  ),
                ),
              ),

              const SizedBox(height: 8),

              ///////////////////////////////////:
              ///////////////////////////////////////////////////////////
              /////////////////////////////////////////////////////////////
              if (user != null)
                Container(
                  constraints: const BoxConstraints(maxWidth: 768),
                  child: StreamBuilder<QuerySnapshot<CareGiverInMyPatientData>>(
                    stream: caregiversInMyPatientsCollection
                        .queryBy(queryOfInPatient)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        print('Error: ${snapshot.error.toString()}');
                        return Center(
                          child: Text(snapshot.error.toString()),
                        );
                      }

                      if (snapshot.hasData &&
                          snapshot.connectionState == ConnectionState.active) {
                        final dataOfInPatient = snapshot.requireData;

                        return dataOfInPatient.size != 0
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Divider(),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(16, 0, 0, 0),
                                    child:
                                        Text(translation(context).myCaregivers),
                                  ),
                                  const SizedBox(height: 8),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: dataOfInPatient.size,
                                    itemBuilder: (context, index) {
                                      return _CareGiverInMyPatientItem(
                                        user: user,
                                        caregiver:
                                            dataOfInPatient.docs[index].data(),
                                        documentReference:
                                            dataOfInPatient.docs[index].id,
                                      );
                                    },
                                  ),
                                ],
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Divider(),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(16, 0, 0, 0),
                                    child:
                                        Text(translation(context).myCaregivers),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(translation(context).noRequestYet),
                                ],
                              );
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                ),

              ///////////////////////////////////////////////////////////
              //  const SizedBox(height: 20),
              ///////////////////////////////////////////////////////////

              ///////////////////////////////////////////////////////////
              Container(
                constraints: const BoxConstraints(maxWidth: 768),
                child: StreamBuilder<QuerySnapshot<CareGiverData>>(
                  stream: caregiversInCareGiverCollection
                      .queryBy(queryCaregiversSearchBox)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      print('Error: ${snapshot.error.toString()}');
                      return Center(
                        child: Text(snapshot.error.toString()),
                      );
                    }

                    if (snapshot.hasData &&
                        snapshot.connectionState == ConnectionState.active) {
                      final data1a = snapshot.requireData;

                      return data1a.size != 0
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 8.0),
                                const Divider(),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(16, 0, 0, 0),
                                  child: Text(translation(context).fromSearch),
                                ),
                                //       const SizedBox(height: 20),
                                ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: data1a.size,
                                  itemBuilder: (context, index) {
                                    return _CareGiverItem(
                                      user: user,
                                      caregiver: data1a.docs[index].data(),
                                      documentReference: data1a.docs[index].id,
                                    );
                                  },
                                ),
                              ],
                            )
                          : Container();
//   const Text('');
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
              ///////////////////////////////////////////////////////
              ///////////////////////////////////////////////////////////
              Container(
                constraints: const BoxConstraints(maxWidth: 768),
                child: StreamBuilder<QuerySnapshot<CareGiverData>>(
                  stream: caregiversInCareGiverCollection
                      .queryBy(query1a)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      print('Error: ${snapshot.error.toString()}');
                      return Center(
                        child: Text(snapshot.error.toString()),
                      );
                    }

                    if (snapshot.hasData &&
                        snapshot.connectionState == ConnectionState.active) {
                      final data1a = snapshot.requireData;

                      return data1a.size != 0
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Divider(),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(16, 0, 0, 0),
                                  child: Text(
                                      translation(context).filterByFirstName),
                                ),
                                const SizedBox(height: 8),
                                ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: data1a.size,
                                  itemBuilder: (context, index) {
                                    return _CareGiverItem(
                                      user: user,
                                      caregiver: data1a.docs[index].data(),
                                      documentReference: data1a.docs[index].id,
                                    );
                                  },
                                ),
                              ],
                            )
                          : Container();
//   const Text('');
                    } else {
                      return Container();
//                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
              ///////////////////////////////////////////////////////
              Container(
                constraints: const BoxConstraints(maxWidth: 768),
                child: StreamBuilder<QuerySnapshot<CareGiverData>>(
                  stream: caregiversInCareGiverCollection
                      .queryBy(query1b)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      print('Error: ${snapshot.error.toString()}');
                      return Center(
                        child: Text(snapshot.error.toString()),
                      );
                    }

                    if (snapshot.hasData &&
                        snapshot.connectionState == ConnectionState.active) {
                      final data1b = snapshot.requireData;

                      return data1b.size != 0
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Divider(),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(16, 0, 0, 0),
                                  child:
                                      Text(translation(context).filterByName),
                                ),
                                const SizedBox(height: 8),
                                ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: data1b.size,
                                  itemBuilder: (context, index) {
                                    return _CareGiverItem(
                                      user: user,
                                      caregiver: data1b.docs[index].data(),
                                      documentReference: data1b.docs[index].id,
                                    );
                                  },
                                ),
                              ],
                            )
                          : Container();
//   const Text('');
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
              //////////////////////////////////////////////
              Container(
                constraints: const BoxConstraints(maxWidth: 768),
                child: StreamBuilder<QuerySnapshot<CareGiverData>>(
                  stream: caregiversInCareGiverCollection
                      .queryBy(query2)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      print('Error: ${snapshot.error.toString()}');
                      return Center(
                        child: Text(snapshot.error.toString()),
                      );
                    }

                    if (snapshot.hasData &&
                        snapshot.connectionState == ConnectionState.active) {
                      final data2 = snapshot.requireData;

                      return data2.size != 0
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Divider(),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(16, 0, 0, 0),
                                  child: Text(
                                      translation(context).filterByFullName),
//                                  child: Text("FILTRE PAR NOM COMPLET"),
                                ),
                                const SizedBox(height: 8),
                                ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: data2.size,
                                  itemBuilder: (context, index) {
                                    return _CareGiverItem(
                                      user: user,
                                      caregiver: data2.docs[index].data(),
                                      documentReference: data2.docs[index].id,
                                    );
                                  },
                                ),
                              ],
                            )
                          : Container();
//   const Text('');
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
              /////////////////////////////////////////////////////////////
              if (user != null)
//              if (user != null && path == '')
                Container(
                  constraints: const BoxConstraints(maxWidth: 768),
                  child: StreamBuilder<
                      QuerySnapshot<CareGiverDataFromConsultationRequests>>(
                    stream: caregiversInConsultationRequestsCollection
                        .queryBy(query6)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        print('Error: ${snapshot.error.toString()}');
                        return Center(
                          child: Text(snapshot.error.toString()),
                        );
                      }

                      if (snapshot.hasData &&
                          snapshot.connectionState == ConnectionState.active) {
                        final data6 = snapshot.requireData;
                        return data6.size != 0
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Divider(),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(16, 0, 0, 0),
                                    child: Text(translation(context)
                                        .fromPastConsultationRequest),
                                  ),
                                  const SizedBox(height: 8),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: data6.size,
                                    itemBuilder: (context, index) {
                                      return _CareGiverItemForConsultationRequests(
                                        data6.docs[index].data(),
                                        data6.docs[index].id,
                                      );
                                    },
                                  ),
                                ],
                              )
                            : Container();
//   const Text('');
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                ),

              ///////////////////////////////////////////////////////////
              //  const SizedBox(height: 20),
              ///////////////////////////////////////////////////////////
            ],
          ),
        ),
      ),
      bottomNavigationBar: bottomMenuProcaryoteWidget(),
    ));
  }



/*
  @override
  Widget build(BuildContext context) {
 
    return Scaffold(

      appBar: AppBar(
        centerTitle: true,
        title: Text(translation(context).myCaregivers),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        actions: (newLoggedUser == null)
            ? <Widget>[
                applicationListButtonWidget(widget.isCaregiverMode),
                const SizedBox(width: 24.0),
                LanguagePickerWidget(),
                const SizedBox(width: 24.0),
                accountButtonWidget(),
                const SizedBox(width: 16.0),
              ]
            : <Widget>[
                IconButton(
                  icon: const Icon(Icons.markunread_mailbox_outlined),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const ConsultationRequestList();
                    }));
                  },
                ),
                accountButtonConnectedWidget(
                    applicationName, widget.isCaregiverMode),
                const SizedBox(width: 16.0),
//                LanguagePickerWidget(),
/*
                IconButton(
                  icon: Icon(Icons.supervised_user_circle_outlined),
//                  icon: Icon(FontAwesomeIcons.userDoctor),
                  onPressed: () async {
                    user = await Navigator.push(context,
                        MaterialPageRoute(builder: (context) => MyDoctors()));
                    if (user != null) {
                      setState(() {
                        this.user = user;
                      });
                    }
                  },
                ),
*/
/*
                PopupMenuButton(
                    icon: const Icon(Icons.account_circle_outlined),
                    itemBuilder: (BuildContext contextFiltered) {
                      return [
                        PopupMenuItem<int>(
                          value: 0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.account_circle_outlined,
                                    size: 20,
                                    color: Color.fromARGB(255, 3, 83, 94),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    translation(context).myProfile,
                                    style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  const Divider(color: Colors.black)
                                ],
                              ),
                            ],
                          ),
                        ),
                        PopupMenuItem<int>(
                          value: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.logout,
                                    size: 20,
                                    color: Color.fromARGB(255, 3, 83, 94),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    translation(context).signOut,
//                                    'Se déconnecter',
                                    style: const TextStyle(
//                                color: Colors.black54,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  const Divider(color: Colors.black)
                                ],
                              ),
                            ],
                          ),
                        ),
                      ];
                    },
                    onSelected: (value) {
                      if (value == 0) {
                        User? user = FirebaseAuth.instance.currentUser;
                        if (user != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProfilePage(user: user)),
                          );
                        }
                        ;
                      } else if (value == 1) {
                        signOut();
                      }
                    }),
                    */
              ],
      ),



      body: Center(
        
        child: Column(
          
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
*/




}



////////////////////////////////////////////////////////////
String caregiverpictureStrbefore =
    "https://firebasestorage.googleapis.com/v0/b/procaryote-1.appspot.com/o/Profile%2FPicture%2F";
//String caregiverpictureStrbefore =
//    "https://firebasestorage.googleapis.com/v0/b/procaryote-1.appspot.com/o/Profile%2FPicture%2F";
String caregiverpictureStrafter =
    "%2Fpicture.png?alt=media&token=10d1b1ee-25bf-4ba1-8d04-3b7d55fe82c3";

//String caregiverpictureStrafter =
//    "picture.png?alt=media&token=10d1b1ee-25bf-4ba1-8d04-3b7d55fe82c3";
////////////////////////////////////////////////////////////////
class _CareGiverInMyPatientItem extends StatefulWidget {
  final User? user;
  final CareGiverInMyPatientData caregiver;
  final String documentReference;

  _CareGiverInMyPatientItem(
      {Key? key,
      this.user,
      required this.caregiver,
      required this.documentReference})
      : super(key: key);

  @override
  _CareGiverInMyPatientItemState createState() =>
      _CareGiverInMyPatientItemState();
}

class _CareGiverInMyPatientItemState extends State<_CareGiverInMyPatientItem> {
  User? newLoggedUser;

  Future<void> _navigateToLoginPage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );

    if (result != null) {
      if (!mounted) return;
      setState(() {
        newLoggedUser = result as User;
      });
    }
  }

  Widget get status {
    return Text(
      '${widget.caregiver.statusStr}',
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget get caregiverid {
    return Text(
      '${widget.caregiver.caregiverUid}',
    );
  }

  Widget get caregiverpicture {
    return Image.network(
      '$caregiverpictureStrbefore${widget.caregiver.caregiverUid}$caregiverpictureStrafter',
      errorBuilder:
          (BuildContext context, Object exception, StackTrace? stackTrace) {
        return const Icon(
          Icons.person,
        );
      },
    );
  }

  String _userAsCaregiverNameString = "";
  String _userAsCaregiverRoleString = "";
  String _userAsCaregiverRegionString = "";

  String? statusConnexionDemandPending = "";

  @override
  void initState() {
    super.initState();

    newLoggedUser = widget.user;

    //////////////////////////////////////

    //  statusConnexionDemandPending = widget.caregiver.statusStr;

    //////////////////////////////////////

    Future.delayed(Duration.zero, () async {
      final collectionRef = FirebaseFirestore.instance.collection('users');
      final snapshot =
          await collectionRef.doc(widget.caregiver.caregiverUid).get();

      Map<String, dynamic>? dataUsers = snapshot.data();

      String caregiverFirstNameStr = dataUsers?['firstName'] ?? '';
      String caregiverLastNameStr = dataUsers?['lastName'] ?? '';
      String caregiverRoleStr = dataUsers?['role'] ?? '';
      String caregiverRegionStr = dataUsers?['region'] ?? '';

      if (mounted) {
        setState(() {
          statusConnexionDemandPending = widget.caregiver.statusStr;

          _userAsCaregiverNameString =
              caregiverFirstNameStr + " " + caregiverLastNameStr;

          _userAsCaregiverRoleString = caregiverRoleStr;
          _userAsCaregiverRegionString = caregiverRegionStr;
        });
      }
    });
  }

  Widget getTrailingWidget() {
    if (statusConnexionDemandPending == "No demand") {
      return const Icon(Icons.group_add);
    } else if (statusConnexionDemandPending == "Accepted") {
      return const Icon(
        Icons.keyboard_arrow_right_sharp,
        size: 48.0,
      );
    } else if (statusConnexionDemandPending == "Pending") {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              statusConnexionDemandPending = "Refused";

              DocumentReference docRef = FirebaseFirestore.instance
                  .collection('my_patients')
                  .doc(widget.documentReference);

              docRef.update({'status': 'Refused'});
            },
          ),
//      return Text(translation(context).acceptRequest);

          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              statusConnexionDemandPending = "Accepted";

              DocumentReference docRef = FirebaseFirestore.instance
                  .collection('my_patients')
                  .doc(widget.documentReference);

              docRef.update({'status': 'Accepted'});
            },
          ),
        ],
      );
    } else {
      return const Icon(
        Icons.block,
        size: 48.0,
      );

//      return SizedBox(); // Aucun trailing
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4, top: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: caregiverpicture,
            title: _userAsCaregiverNameString == null
                ? const CircularProgressIndicator()
                : Text(_userAsCaregiverNameString),
            subtitle: _userAsCaregiverRoleString == null
                ? const Text(" ")
                : Text(_userAsCaregiverRoleString +
                    " - " +
                    _userAsCaregiverRegionString),
//            subtitle: roleAndLocation,
            isThreeLine: false,
            trailing: getTrailingWidget(),
/*
            trailing: Icon(
              Icons.keyboard_arrow_right_sharp,
              size: 48.0,
            ),
*/
            onTap: () async {
              if (newLoggedUser == null) {
                _navigateToLoginPage();
              } else {
                if (statusConnexionDemandPending == "Accepted") {



/*

CHANGE FROM CONSULT ==> FLOW
=======================================



                  if (accessToPlanner == "All users") {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => FreeTimePage(
                          requestedCareGiverID:
                              '${widget.caregiver.caregiverUid}',
                        ),
                      ),
                    );
                  } else {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => SurveyScreen1(
//                    user: user,
                          documentReferenceID: "",
                          requestedCareGiverID: '${widget.documentReference}',
                        ),
                      ),
                    );
                  }


*/


                }
              }
            },
          ),
        ],
      ),
    );
  }
}





@immutable
class CareGiverInMyPatientData {
  const CareGiverInMyPatientData({
    required this.caregiverUid,
    required this.patientUid,
    required this.statusStr,
  });

  // deserialize the data from a json object
  CareGiverInMyPatientData.fromJson(Map<String, Object?> json)
      : this(
          caregiverUid: json['caregiverUserID'] != null
              ? json['caregiverUserID'] as String
              : '', // check ? to prevent null error
          patientUid: json['patientUserID'] != null
              ? json['patientUserID'] as String
              : '', // check ? to prevent null error
          statusStr: json['status'] != null
              ? json['status'] as String
              : '', // check ? to prevent null error
        );

  final String? caregiverUid;
  final String? patientUid;
  final String? statusStr;

  Map<String, Object?> toJson() {
    return {
      if (caregiverUid != null) 'caregiverUid': caregiverUid,
      if (patientUid != null) 'patientUid': patientUid,
      if (statusStr != null) 'status_str': statusStr,
    };
  }
}

////////////////////////////////////////////////////////////
class _CareGiverItem extends StatefulWidget {
  final User? user;
  final CareGiverData caregiver;
  final String documentReference;

  _CareGiverItem(
      {Key? key,
      this.user,
      required this.caregiver,
      required this.documentReference})
      : super(key: key);

  @override
  _CareGiverItemState createState() => _CareGiverItemState();
}

class _CareGiverItemState extends State<_CareGiverItem> {
  User? newLoggedUser;

  @override
  void initState() {
    super.initState();

    newLoggedUser = widget.user;
  }

  Future<void> _navigateToLoginPage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );

    if (result != null) {
      if (!mounted) return;
      setState(() {
        newLoggedUser = result as User;
      });
    }
  }

  Widget get details {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          caregivername,
          roleAndLocation,
        ],
      ),
    );
  }

  Widget get caregivername {
    return Text(
      '${widget.caregiver.Title} ${widget.caregiver.FirstName} ${widget.caregiver.LastName}',
      //style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget get roleAndLocation {
    return Text(
      '${widget.caregiver.Role} - ${widget.caregiver.Region}',
      //style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget get status {
    return Text(
      '${widget.caregiver.statusStr}',
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget get caregiverid {
    return Text(
      '${widget.caregiver.id}',
    );
  }

  Widget get caregiverpicture {
    return Image.network(
      '$caregiverpictureStrbefore${widget.caregiver.id}$caregiverpictureStrafter',
      errorBuilder:
          (BuildContext context, Object exception, StackTrace? stackTrace) {
        return const Icon(
          Icons.person,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4, top: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: caregiverpicture,
            title: caregivername,
            subtitle: roleAndLocation,
            isThreeLine: false,
            trailing: const Icon(
              Icons.keyboard_arrow_right_sharp,
              size: 48.0,
            ),
            onTap: () async {
              if (newLoggedUser == null) {
                _navigateToLoginPage();
              } else {


/*
CHANGE FROM CONSULT ==> FLOW
=======================================


                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SurveyScreen1(
//                    user: user,
                      documentReferenceID: "",
                      requestedCareGiverID: '${widget.documentReference}',
                    ),
                  ),
                );
*/


              }
            },
          ),
        ],
      ),
    );
  }
}

@immutable
class CareGiverData {
  const CareGiverData({
    required this.Title,
    required this.FirstName,
    required this.LastName,
    required this.Role,
//    required this.Picture,
    required this.Region,
    required this.id,
    required this.statusStr,
  });

  // deserialize the data from a json object
  CareGiverData.fromJson(Map<String, Object?> json)
      : this(
          Title: json['title'] != null
              ? json['title'] as String
              : '', // check ? to prevent null error
          FirstName: json['firstName'] != null
              ? json['firstName'] as String
              : '', // check ? to prevent null error
          LastName: json['lastName'] != null
              ? json['lastName'] as String
              : '', // check ? to prevent null error
          Role: json['role'] != null
              ? json['role'] as String
              : '', // check ? to prevent null error
//cg>u          Picture: json['Picture'] != null
//cg>u              ? json['Picture'] as String
//cg>u              : '', // check ? to prevent null error
          Region: json['region'] != null
              ? json['region'] as String
              : '', // check ? to prevent null error
          id: json['updateUid'] != null
              ? json['updateUid'] as String
              : '', // check ? to prevent null error
//cg>u          id: json['id'] != null
//cg>u              ? json['id'] as String
//cg>u              : '', // check ? to prevent null error
          statusStr: json['status'] != null
              ? json['status'] as String
              : '', // check ? to prevent null error
//cg>u          Title: json['Title'] != null
//cg>u              ? json['Title'] as String
//cg>u              : '', // check ? to prevent null error
//cg>u          FirstName: json['Firstname'] != null
//cg>u              ? json['Firstname'] as String
//cg>u              : '', // check ? to prevent null error
//cg>u          LastName: json['Lastname'] != null
//cg>u              ? json['Lastname'] as String
//cg>u              : '', // check ? to prevent null error
//cg>u          Role: json['Role'] != null
//cg>u              ? json['Role'] as String
//cg>u              : '', // check ? to prevent null error
//cg>u          Picture: json['Picture'] != null
//cg>u              ? json['Picture'] as String
//cg>u              : '', // check ? to prevent null error
//cg>u          Region: json['Region'] != null
//cg>u              ? json['Region'] as String
//cg>u              : '', // check ? to prevent null error
//cg>u          id: json['id'] != null
//cg>u              ? json['id'] as String
//cg>u              : '', // check ? to prevent null error
//cg>u          statusStr: json['status_str'] != null
//cg>u              ? json['status_str'] as String
//cg>u              : '', // check ? to prevent null error
        );

  final String? Title;
  final String? FirstName;
  final String? LastName;
  final String? Role;
//cg>u  final String? Picture;
  final String? Region;
  final String? id;
  final String? statusStr;

  Map<String, Object?> toJson() {
    return {
      if (Title != null) 'Title': Title,
      if (FirstName != null) 'Firstname': FirstName,
      if (LastName != null) 'Lastname': LastName,
      if (Role != null) 'Role': Role,
//cg>u      if (Picture != null) 'Picture': Picture,
      if (Region != null) 'Region': Region,
      if (id != null) 'id': id,
      if (statusStr != null) 'status_str': statusStr,
    };
  }
}

/// A single CareGiver row.
class _CareGiverItemForConsultationRequests extends StatelessWidget {
  _CareGiverItemForConsultationRequests(this.caregiver, this.documentReference);

  final CareGiverDataFromConsultationRequests caregiver;
  final String documentReference;

  /// Returns details of consultation request.
  Widget get details {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          caregivername,
          roleAndLocation,
        ],
      ),
    );
  }

  /// Return the caregivername.
  Widget get caregivername {
    return Text(
      '${caregiver.careGiverTitle} ${caregiver.careGiverFirstName} ${caregiver.careGiverLastName}',
      //style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  /// Return the caregiver patient.
  Widget get roleAndLocation {
    return Text(
      '${caregiver.careGiverRole} - ${caregiver.careGiverRegion}',
      //style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  /// Return the caregiver status.
  Widget get status {
    return Text(
      '${caregiver.statusStr}',
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  /// Return the caregiver id.
  Widget get caregiverid {
    return Text(
      '${caregiver.careGiverId}',
    );
//    return Text(
//      '${caregiver.id}',
//    );
  }

  /// Return the caregiverpicture.
  Widget get caregiverpicture {
    return Image.network(
      '$caregiverpictureStrbefore${caregiver.careGiverId}$caregiverpictureStrafter',
      errorBuilder:
          (BuildContext context, Object exception, StackTrace? stackTrace) {
        return const Icon(
          Icons.person,
//          color: Colors.white,
//          size: 80,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4, top: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
//          Flexible(
          ListTile(
//              child: ListTile(
            //   leading: const CircleAvatar(backgroundColor: Colors.blue),

            leading: caregiverpicture,
//            leading: Image.network(
//              caregiverpictureStr,
//              caregiverpicture,
//              "https://firebasestorage.googleapis.com/v0/b/procaryote-1.appspot.com/o/Profile%2FPicture%2Fpic25472.png?alt=media&token=10d1b1ee-25bf-4ba1-8d04-3b7d55fe82c3',
//            ),

//            title: caregiverid,
            title: caregivername,
//            subtitle: status,
//            subtitle: rationalePlusCreationDate,
            subtitle: roleAndLocation,
//            subtitle: Text('$documentReference'),
//            subtitle: Text('${caregiver.careGiverId}'),
            isThreeLine: false,
            trailing: const Icon(
              Icons.keyboard_arrow_right_sharp,
              size: 48.0,
            ),

/*
            trailing: Column(
              children: [
//                CreationDate,
                Icon(Icons.keyboard_arrow_right_sharp),
              ],
            ),
*/
//            trailing: const Icon(Icons.keyboard_arrow_right_sharp),
            onTap: () {





/*



CHANGE FROM CONSULT ==> FLOW
=======================================



              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => SurveyScreen1(
//                    user: user,
                    documentReferenceID: "",
                    requestedCareGiverID: '${caregiver.careGiverId}',
//                    requestedCareGiverID: '${documentReference}',
                  ),
                ),
              );



              */
            },
          ),
        ],
      ),
    );
  }
}

@immutable
class CareGiverDataFromConsultationRequests {
  const CareGiverDataFromConsultationRequests({
    required this.careGiverTitle,
    required this.careGiverFirstName,
    required this.careGiverLastName,
    required this.careGiverRole,
    required this.careGiverRegion,
//    required this.careGiverPicture,
    required this.careGiverId,
    required this.statusStr,
  });

  // deserialize the data from a json object
  CareGiverDataFromConsultationRequests.fromJson(Map<String, Object?> json)
      : this(
          careGiverTitle: json['careGiverTitle'] != null
              ? json['careGiverTitle'] as String
              : '', // check ? to prevent null error
          careGiverFirstName: json['careGiverFirstName'] != null
              ? json['careGiverFirstName'] as String
              : '', // check ? to prevent null error
          careGiverLastName: json['careGiverLastName'] != null
              ? json['careGiverLastName'] as String
              : '', // check ? to prevent null error
          careGiverRole: json['careGiverRole'] != null
              ? json['careGiverRole'] as String
              : '', // check ? to prevent null error
//          careGiverPicture: json['careGiverPicture'] != null
//              ? json['careGiverPicture'] as String
//              : '', // check ? to prevent null error
          careGiverRegion: json['careGiverRegion'] != null
              ? json['careGiverRegion'] as String
              : '', // check ? to prevent null error
          careGiverId: json['care_giver_user_uid'] != null
              ? json['care_giver_user_uid'] as String
              : '', // check ? to prevent null error
          statusStr: json['status_str'] != null
              ? json['status_str'] as String
              : '', // check ? to prevent null error
        );

  final String? careGiverTitle;
  final String? careGiverFirstName;
  final String? careGiverLastName;
  final String? careGiverRole;
//  final String? careGiverPicture;
  final String? careGiverRegion;
  final String? careGiverId;
  final String? statusStr;

  Map<String, Object?> toJson() {
    return {
      if (careGiverTitle != null) 'careGiverTitle': careGiverTitle,
      if (careGiverFirstName != null) 'careGiverFirstName': careGiverFirstName,
      if (careGiverLastName != null) 'careGiverLastName': careGiverLastName,
      if (careGiverRole != null) 'careGiverRole': careGiverRole,
//      if (careGiverPicture != null) 'careGiverPicture': careGiverPicture,
      if (careGiverRegion != null) 'careGiverRegion': careGiverRegion,
      if (careGiverId != null) 'care_giver_user_uid': careGiverId,
      if (statusStr != null) 'status_str': statusStr,
    };
  }
}
