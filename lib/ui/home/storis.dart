import 'dart:async';
// ignore: unused_import
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../constants/fonts.dart';
import '../../data/providers.dart';


class Storis extends ConsumerStatefulWidget {
  const Storis({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _StorisState();
}

class _StorisState extends ConsumerState<Storis> with SingleTickerProviderStateMixin {

  List<String> headers = [
    '-10% на молоко',
    '-20% на говядину',
    '-15% на сыры',
    '-5% на европейские соусы'
  ];

  // final List<Color> screenColors = [orangeColor, accentBlueColor, blueColor, purpleColor];
  final List<String> bgPath = [
    'https://www.gogetyourself.com/wp-content/uploads/2021/12/How-to-Make-Rice-Water-for-Plants.jpg', 
    'https://eda-iz-derevni.ru/upload/iblock/202/20260d5faa27996925e837f6052d000c.jpeg', 
    'https://milk.ingredients.pro/upload/iblock/93f/Propionic-Type_min.jpeg', 
    'https://i.pinimg.com/originals/75/48/9c/75489ca4bd833c9afed9fd9e892e09a8.jpg'
  ];
  final PageController _pageController = PageController();
  Timer? _timer;
  Timer? _progressTimer; // Добавлен второй таймер для прогресса
  int _currentPage = 0;
  final int _numPages = 4;
  double _currentProgress = 0.0;

  late bool isLogined;

  AnimationController? _controller;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));
    _startTimer();
    _startProgressTimer(); // инициализация таймера прогресса
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
  }

  void _startTimer() {
    const period = Duration(seconds: 5);
    _timer?.cancel(); // Отмена существующего таймера, если он есть
    _timer = Timer.periodic(period, (timer) {
      _nextPage();
    });
  }

  Future<void> route() async {}

  void _nextPage() {
    if (!mounted) return;
    if (_currentPage == _numPages - 1){
      ref.read(bottomNavVisibleProvider.notifier).state = true;
      Navigator.of(context).pop();
    } else {
      setState(() {
        _currentPage = (_currentPage + 1) % _numPages;
        _currentProgress = 0.0; // Сброс прогресса при смене страницы
      });
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.fastEaseInToSlowEaseOut,
      );
    }
  }

  void _startProgressTimer() {
    _progressTimer?.cancel(); // Отмените существующий таймер прогресса, если он есть
    // Обновление прогресса каждые 50 мс для плавности анимации
    _progressTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (_currentProgress < 1) {
        setState(() {
          _currentProgress += 0.01;
        });
      }
    });
  }

  void _pauseTimers() {
    _timer?.cancel();
    _progressTimer?.cancel(); // Приостановить оба таймера
  }

  void _resumeTimers() {
    _startTimer();
    _startProgressTimer(); // Возобновить оба таймера
  }

  @override
  void dispose() {
    _timer?.cancel();
    _progressTimer?.cancel(); // Отмена таймера прогресса
    _pageController.dispose();
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (result){
        ref.read(bottomNavVisibleProvider.notifier).state = true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: _numPages,
              onPageChanged: (page) {
                setState(() {
                  _timer?.cancel();
                  _progressTimer?.cancel();
                  _currentPage = page;
                  _currentProgress = 0.0; // Сброс прогресса при ручном перелистывании
                  _startTimer();
                  _startProgressTimer();
                });
              },
              itemBuilder: (context, index) {
                return GestureDetector(
                  onLongPressStart: (details) => _pauseTimers(),
                  onLongPressEnd: (details) {_nextPage(); _resumeTimers();},
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      image: DecorationImage(
                        opacity: 1,
                        image: NetworkImage(bgPath[index]),
                        fit: BoxFit.cover,
                        // alignment: Alignment.bottomCenter,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Colors.black45,
                            borderRadius: BorderRadius.circular(0),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          child: Text(headers[index], style: white(50, FontWeight.w800),)
                        ),
                      ],
                    )
                  ),
                );
              },
            ),
            Positioned(
              top: 30,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 3),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_numPages, (index) => _buildProgressIndicator(index)),
                ),
              ),
            ),
            Positioned(
              top: 50,
              right: 10,
              child: InkWell(
                onTap: (){
                  ref.read(bottomNavVisibleProvider.notifier).state = true;
                  Navigator.of(context).pop();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 3),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Icon(MdiIcons.close, color: Colors.white, size: 30,)
                ),
              ),
            ),
          ],
        ),
        /*
        floatingActionButton: SizedBox(
          height: 45,
          width: 150,
          child: FloatingActionButton.extended(
            backgroundColor: Colors.black,
            onPressed: () {
              // isLogined ? Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const MainScreen())) :
              // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const AuthScreen()));
            },
            label: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(15)), // Закругление должно совпадать с кнопкой
              child: SizedBox(
                width: 150,
                height: 45, // Размеры должны соответствовать размеру кнопки
                child: Stack(
                  children: [
                    Align(alignment: Alignment.center, child: Text('закрыть', style: white(14))),
                    AnimatedBuilder(
                      animation: _controller!,
                      builder: (context, child) {
                        return Positioned(
                          left: _controller!.value * 300 - 150, // Анимируем позицию полосы
                          top: -50,
                          child: Transform.rotate(
                            angle: math.pi / 1,
                            child: Opacity(
                              opacity: 0.999,
                              child: Container(
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: [
                                      Colors.transparent,
                                      Colors.white,
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                                width: 100,
                                height: 200,
                                // color: Colors.white,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        */
      ),
    );
  }

  Widget _buildProgressIndicator(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1.5),
      child: Container(
        width: MediaQuery.of(context).size.width / _numPages - 8, // Адаптация ширины индикатора
        height: 3, // Высота индикатора
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          color: Colors.white.withOpacity(0.3), // Фон для индикатора, который не заполняется
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: _currentPage == index ? _currentProgress : 0,
            backgroundColor: Colors.transparent, // Сделайте фон прозрачным, чтобы был виден только прогресс
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            minHeight: 4,
          ),
        ),
      ),
    );
  }
}