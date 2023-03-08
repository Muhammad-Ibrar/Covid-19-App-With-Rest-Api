import 'dart:convert';

import 'package:covid_19_app_with_rest_api/Services/Utilities/api_uri.dart';
import 'package:http/http.dart' as http;
import 'package:covid_19_app_with_rest_api/Models/world_state_model.dart';

class StatesServices {

  Future<WorldStateModel> fetchWorldState () async{

    final response = await http.get(Uri.parse(AppUrl.worldStateApi));

    if(response.statusCode == 200){
      // var data;
      // print(data);
     var data = jsonDecode(response.body);
      return WorldStateModel.fromJson(data);
    }
    else
      {
        throw Exception('Error');
      }
  }

  Future<List<dynamic>> countriesList () async{

    var data;
    final response = await http.get(Uri.parse(AppUrl.countriesList));

    if(response.statusCode == 200){

      data = jsonDecode(response.body);
      return data;
    }
    else
    {
      throw Exception('Error');
    }
  }

}

