import 'package:covid_19_app_with_rest_api/Models/world_state_model.dart';
import 'package:covid_19_app_with_rest_api/Services/states_services.dart';
import 'package:covid_19_app_with_rest_api/view/countries_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pie_chart/pie_chart.dart';

class WorldStateScreen extends StatefulWidget {
  const WorldStateScreen({Key? key}) : super(key: key);

  @override
  State<WorldStateScreen> createState() => _WorldStateScreenState();
}

class _WorldStateScreenState extends State<WorldStateScreen> with TickerProviderStateMixin {


  late final AnimationController _controller = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this)..repeat();

  @override

  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  final colorList = <Color>[
   const Color(0xff4285F4),
   const Color(0xff1aa260),
   const  Color(0xffde5246)
  ];

  @override
  Widget build(BuildContext context) {
    StatesServices statesServices = StatesServices();
    return Scaffold(
      appBar: AppBar(
        title:const Text('World State Screen'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height*.03),
              FutureBuilder(
                future: statesServices.fetchWorldState(),
                  builder: (context ,AsyncSnapshot<WorldStateModel> snapshot){


                    if( !snapshot.hasData){
                      return Expanded(
                        flex: 1,
                          child: SpinKitFadingCircle(
                            color: Colors.white,
                            size: 50.0,
                            controller: _controller,
                          )
                      );
                    }
                    else {
                      return Column(
                        children: [
                          PieChart(
                            dataMap:{
                              "Total" : double.parse(snapshot.data!.cases!.toString()),
                              // "Total" : 20,
                              "Recovered" :  double.parse(snapshot.data!.recovered.toString() ),
                              // "Recovered" : 15,
                              "Death" :  double.parse(snapshot.data!.deaths.toString()),
                              // "Death" : 5
                            },
                            chartValuesOptions:const ChartValuesOptions(
                              showChartValuesInPercentage: true
                            ),
                            chartRadius: MediaQuery.of(context).size.width/3.2,
                            legendOptions:const LegendOptions(
                                legendPosition: LegendPosition.left
                            ),
                            animationDuration:const Duration(milliseconds: 1000),
                            chartType: ChartType.ring,
                            colorList:colorList,
                          ),
                          const SizedBox(height: 10,),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.height*.001),
                            child: Card(
                              child: Column(
                                children: [
                                  ReusableRow(title: 'Total', value: snapshot.data!.cases.toString()),
                                  ReusableRow(title: 'Deaths', value: snapshot.data!.deaths.toString()),
                                  ReusableRow(title: 'Recovered', value: snapshot.data!.recovered.toString()),
                                  ReusableRow(title: 'Active', value: snapshot.data!.active.toString()),
                                  ReusableRow(title: 'Affected Countries', value: snapshot.data!.affectedCountries.toString()),
                                  ReusableRow(title: 'Critical', value: snapshot.data!.critical.toString()),

                                ],
                              ),
                            ),
                          ),
                         const SizedBox(height: 10),
                          GestureDetector(
                            onTap: (){
                           Navigator.push(context, MaterialPageRoute(builder: (context)=> CountriesListScreen()))  ;
                    },
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                  color: Color(0xff1aa260),
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              child:const Center(
                                child: Text('Track Countries'),
                              ),
                            ),
                          )
                        ],
                      );
                    }
                  }),

            ],
          ),
        ),
      )
    );
  }
}

class ReusableRow extends StatelessWidget {
  String title , value;
   ReusableRow({Key? key , required this.title , required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10 , right: 10 , top: 10, bottom: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title),
              Text(value)
            ],
          ),
         const SizedBox(
            height: 10,
          ),
         const Divider()
        ],

      ),
    );
  }
}
