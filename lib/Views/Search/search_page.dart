import 'package:flutter/material.dart';
import 'package:statomo_application/Views/Search/search_page_all.dart';
import 'package:statomo_application/utils/widget_utils.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String? subject = 'NationalLanguage';

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: WidgetUtils.createAppBar('部屋を検索'),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 100,),
              Padding(
                padding: const EdgeInsets.all(10.0),
                // ignore: sized_box_for_whitespace
                child: Container(
                  height: 80,
                  child: Row(
                    children: [
                      const Text(
                        '教科:',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 100),
                      SizedBox(
                        width: 120,
                        child: DropdownButtonFormField(
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.blue.withOpacity(0.5)),
                          items: const [
                            DropdownMenuItem(
                                value: 'NationalLanguage',
                                child: Text('国語')),
                            DropdownMenuItem(value: 'Math', child: Text('数学')),
                            DropdownMenuItem(
                                value: 'English',
                                child: Text('英語')),
                            DropdownMenuItem(
                                value: 'Science',
                                child: Text('理科')),
                            DropdownMenuItem(
                                value: 'Society',
                                child: Text('社会')),
                            DropdownMenuItem(
                                value: 'Blank',
                                child: Text('その他')),
                          ],
                          onChanged: (String? value) {
                            setState(() {
                              subject = value;
                            });
                          },
                          value: subject,
                          isExpanded: true,
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              // ignore: sized_box_for_whitespace
              Container(
                height: 100,
                child: Center(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.blue,
                      minimumSize: const Size(150, 70),
                    ),
                    child: const Text(
                      '検索',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 30),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SearchPageAll(sub: subject!)));
                    },
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
