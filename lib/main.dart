import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ui_tests/ScheduleComponent.dart';
import 'package:ui_tests/ScheduleItem.dart';
import 'package:ui_tests/wedding_rule_element_struct.dart';
import 'package:ui_tests/wedding_rules.dart';
import 'camera_flutter_flow.dart';
import 'firebase_options.dart';
import 'dart:async';

Future<void> main() async {
  final rules = List<WeddingRuleElementStruct>.empty(growable: true);
  rules.add(WeddingRuleElementStruct("This is a test", "jbnfbjnfobnerobjiojroiejfiovejrbvnieheirhvrehjvkjhdfskjhvfdjkbjdkfnbjkfdnbjkdfnbjkfndbkjndfjkbndfjknbjkdfnbjkdfnbjkfdnbjkdfnbjkdfnjkbndfjkbndfjknbjkfdnbjkdfnbjkdfnbjkndfbkjndfjkbndfkjnbjkdfnbjkfdnbjkdfnbjkndfjkbndfjknbdjkfnbjkdfnbjkndfjkbnfdjkbnfdjknbjfdnbjkdfnbjknfd"));
  rules.add(WeddingRuleElementStruct("This is a test", "jbnfbjnfobnerobjiojroiejfiovejrbvnieheirhvrehjvkjhdfskjhvfdjkbjdkfnbjkfdnbjkdfnbjkfndbkjndfjkbndfjknbjkdfnbjkdfnbjkfdnbjkdfnbjkdfnjkbndfjkbndfjknbjkfdnbjkdfnbjkdfnbjkndfbkjndfjkbndfkjnbjkdfnbjkfdnbjkdfnbjkndfjkbndfjknbdjkfnbjkdfnbjkndfjkbnfdjkbnfdjknbjfdnbjkdfnbjknfd"));
  rules.add(WeddingRuleElementStruct("This is a test", "jbnfbjnfobnerobjiojroiejfiovejrbvnieheirhvrehjvkjhdfskjhvfdjkbjdkfnbjkfdnbjkdfnbjkfndbkjndfjkbndfjknbjkdfnbjkdfnbjkfdnbjkdfnbjkdfnjkbndfjkbndfjknbjkfdnbjkdfnbjkdfnbjkndfbkjndfjkbndfkjnbjkdfnbjkfdnbjkdfnbjkndfjkbndfjknbdjkfnbjkdfnbjkndfjkbnfdjkbnfdjknbjfdnbjkdfnbjknfd"));
  rules.add(WeddingRuleElementStruct("This is a test", "jbnfbjnfobnerobjiojroiejfiovejrbvnieheirhvrehjvkjhdfskjhvfdjkbjdkfnbjkfdnbjkdfnbjkfndbkjndfjkbndfjknbjkdfnbjkdfnbjkfdnbjkdfnbjkdfnjkbndfjkbndfjknbjkfdnbjkdfnbjkdfnbjkndfbkjndfjkbndfkjnbjkdfnbjkfdnbjkdfnbjkndfjkbndfjknbdjkfnbjkdfnbjkndfjkbnfdjkbnfdjknbjfdnbjkdfnbjknfd"));
  rules.add(WeddingRuleElementStruct("This is a test", "jbnfbjnfobnerobjiojroiejfiovejrbvnieheirhvrehjvkjhdfskjhvfdjkbjdkfnbjkfdnbjkdfnbjkfndbkjndfjkbndfjknbjkdfnbjkdfnbjkfdnbjkdfnbjkdfnjkbndfjkbndfjknbjkfdnbjkdfnbjkdfnbjkndfbkjndfjkbndfkjnbjkdfnbjkfdnbjkdfnbjkndfjkbndfjknbdjkfnbjkdfnbjkndfjkbnfdjkbnfdjknbjfdnbjkdfnbjknfd"));
  rules.add(WeddingRuleElementStruct("This is a test", "jbnfbjnfobnerobjiojroiejfiovejrbvnieheirhvrehjvkjhdfskjhvfdjkbjdkfnbjkfdnbjkdfnbjkfndbkjndfjkbndfjknbjkdfnbjkdfnbjkfdnbjkdfnbjkdfnjkbndfjkbndfjknbjkfdnbjkdfnbjkdfnbjkndfbkjndfjkbndfkjnbjkdfnbjkfdnbjkdfnbjkndfjkbndfjknbdjkfnbjkdfnbjkndfjkbnfdjkbnfdjknbjfdnbjkdfnbjknfd"));
  rules.add(WeddingRuleElementStruct("This is a test", "jbnfbjnfobnerobjiojroiejfiovejrbvnieheirhvrehjvkjhdfskjhvfdjkbjdkfnbjkfdnbjkdfnbjkfndbkjndfjkbndfjknbjkdfnbjkdfnbjkfdnbjkdfnbjkdfnjkbndfjkbndfjknbjkfdnbjkdfnbjkdfnbjkndfbkjndfjkbndfkjnbjkdfnbjkfdnbjkdfnbjkndfjkbndfjknbdjkfnbjkdfnbjkndfjkbnfdjkbnfdjknbjfdnbjkdfnbjknfd"));

  final times = List<ScheduleItem>.empty(growable: true);
  times.add(ScheduleItem("2:30 pm", "Ceremonia católica"));
  times.add(ScheduleItem("4:00 pm", "Sesión fotográfica de esposos"));
  times.add(ScheduleItem("4:00 pm", "Mientras los novios se toman sus fotos los invitados a trasladarse a V7CR para la recepción"));
  times.add(ScheduleItem("5:30 pm", "Coctél y Bocadillos de Bienvenida"));
  times.add(ScheduleItem("6:30 pm", "Primer Baile"));
  times.add(ScheduleItem("7:00 pm", "Cena"));
  times.add(ScheduleItem("8:00 pm", "Fiesta!!!!"));
  times.add(ScheduleItem("8:00 pm", "Se abre la barra de licores!"));
  times.add(ScheduleItem("10:30 pm", "A dormir!"));


  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MaterialApp(
      theme: ThemeData.light(),
      home: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Scaffold(
            body: Column(
              // children: [TakePictureScreen(username: 'Bryan Mena', notificationTitle: 'Test', notificationCTA: 'Test', cameraButtonCTA: 'Test', submitCTA: 'Test', retakeCTA: 'Test', snackbarMessage: 'Test',)],
              children: [
                ScheduleComponent(events: times)
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
