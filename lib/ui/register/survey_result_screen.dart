import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:frontend/const/app_color.dart';
import 'package:frontend/const/text_styles.dart';
import 'package:frontend/ui/register/select_family_screen.dart';
import 'package:provider/provider.dart';
import 'package:frontend/provider/register_provider.dart';
import 'package:dio/dio.dart';


class SurveyResultScreen extends StatelessWidget {
  final int totalScore;
  final List<double> responses;
  final _dio = Dio();

  SurveyResultScreen({
    Key? key, 
    required this.totalScore,
    required this.responses,
  }) : super(key: key);

  String getEvaluation() {
    if (totalScore >= 28) {
      return '효도왕! 부모님께 깊은 애정과 관심을 가지고 있으며, 부모님께서도 자랑스러워하실 것입니다.';
    } else if (totalScore >= 21) {
      return '부모님과의 관계가 매우 좋습니다. 앞으로도 지금처럼 관심을 계속 가지신다면 더욱 돈독한 관계가 될 것입니다.';
    } else if (totalScore >= 14) {
      return '부모님과의 관계는 무난한 편이나, 조금 더 신경 쓴다면 훨씬 좋을 것입니다.';
    } else if (totalScore >= 7) {
      return '부모님과의 관계에 조금 더 관심을 가지는 것이 좋습니다. 작은 관심이 큰 변화를 만들 수 있습니다.';
    } else {
      return '부모님과의 관계에 큰 노력이 필요합니다. 부모님께서도 자녀의 관심을 원하고 계실 수 있으니 대화와 만남의 시간을 늘려 보세요.';
    }
  }

  Future<void> _register(BuildContext context) async {
    final registerProvider = context.read<RegisterProvider>();
    
    final adjustedResponses = responses.map((score) => (score + 1).toInt()).toList();
    
    try {
      await _dio.post(
        'https://a043-123-212-9-154.ngrok-free.app/survey',
        data: {
          'user_id': 4,
          'answers': adjustedResponses,
        },
      );
      
      final success = await registerProvider.register();
      if (success) {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => SelectFamilyScreen()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('설문 제출에 실패했습니다. 다시 시도해주세요.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(title: const Text('결과')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '현재 나의 효도점수: $totalScore점',
                style: TextStyles.black20bold,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: width * 0.8,
                child: Text(
                getEvaluation(),
                textAlign: TextAlign.center,
                style: TextStyles.grey16,
              ),),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () => _register(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  fixedSize: Size(width * 0.8, 50),
                ),
                child: const Text('다음', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}