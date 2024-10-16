import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsOverlay extends StatefulWidget {
  final VoidCallback onClose;

  const SettingsOverlay({Key? key, required this.onClose}) : super(key: key);

  @override
  _SettingsOverlayState createState() => _SettingsOverlayState();
}

class _SettingsOverlayState extends State<SettingsOverlay> {
  static AudioPlayer? _player;
  double _volume = 0.0;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _initAudio();
  }

  Future<void> _initAudio() async {
    _player ??= AudioPlayer();
    try {
      if (!(await _player!.getCurrentPosition() != null)) {
        await _player!.setReleaseMode(ReleaseMode.loop);
        await _player!.setSourceAsset('audio/music.mp3');
      }
      _volume = await _player!.volume ?? 0.0;
      _isPlaying = await _player!.state == PlayerState.playing;
      setState(() {});
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned(
          top: MediaQuery.of(context).size.height * .075,
          child: Container(
            height: 70,
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: [
                const SizedBox(
                  width: 20,
                ),
                GestureDetector(
                  onTap: widget.onClose,
                  child: Container(
                    height: 60,
                    width: 60,
                    child: Image.asset('assets/back.png'),
                  ),
                ),
                const Spacer(),
                // Container(
                //   height: 60,
                //   width: 60,
                //   child: Image.asset('assets/howtoplay.png'),
                // ),
                const SizedBox(
                  width: 20,
                ),
              ],
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.35,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            image: const DecorationImage(
              image: AssetImage('assets/settings_container.png'),
              fit: BoxFit.contain,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  const Spacer(),
                  SizedBox(
                    height: 50,
                    width: 50,
                    child: Image.asset('assets/sound_icon.png'),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 200,
                    child: SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: const Color(0xFF4EFDF9),
                        inactiveTrackColor: const Color(0xFF340077),
                        thumbColor: const Color(0xFF4EFDF9),
                        overlayColor: const Color(0x294EFDF9),
                        thumbShape:
                            const RoundSliderThumbShape(enabledThumbRadius: 12),
                        overlayShape:
                            const RoundSliderOverlayShape(overlayRadius: 20),
                      ),
                      child: Slider(
                        value: _volume,
                        min: 0.0,
                        max: 1.0,
                        onChanged: (newVolume) async {
                          setState(() {
                            _volume = newVolume;
                          });
                          await _player?.setVolume(_volume);
                          if (_volume > 0) {
                            if (!_isPlaying) {
                              await _player?.resume();
                              _isPlaying = true;
                            }
                          } else {
                            await _player?.pause();
                            _isPlaying = false;
                          }
                        },
                      ),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
              const SizedBox(height: 20),
              _buildTextButton('Terms of use', () {
                _openUrl('https://barbellwin.online/pixbrainplay-termsofuse');
              }),
              const SizedBox(height: 10),
              _buildTextButton('Privacy Policy', () {
                _openUrl('https://barbellwin.online/pixbrainplay-policy');
              }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTextButton(String text, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 24,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }

  void _openUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: true, forceWebView: false);
    } else {
      throw 'Could not launch $url';
    }
  }
}
