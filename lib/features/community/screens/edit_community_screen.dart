import 'dart:io';
import 'dart:isolate';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/common/error_text.dart';
import 'package:reddit_tutorial/core/common/loader.dart';
import 'package:reddit_tutorial/core/constants/constants.dart';
import 'package:reddit_tutorial/core/utils.dart';
import 'package:reddit_tutorial/features/community/controller/community_controller.dart';
import 'package:reddit_tutorial/models/community_model.dart';
import 'package:reddit_tutorial/theme/pallet.dart';

class EditCommunityScreen extends ConsumerStatefulWidget {
  final String communityName;
  const EditCommunityScreen({super.key, required this.communityName});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditCommunityScreenState();
}

class _EditCommunityScreenState extends ConsumerState<EditCommunityScreen> {
  File? bannerFile;
  File? profileFile;
  void selectBannerImage() async {
    final res = await pickImage();
    if (res != null) {
      setState(() {
        bannerFile = File(res.files.first.path!);
      });
    }
  }

  void selectProfileImage() async {
    final res = await pickImage();
    if (res != null) {
      setState(() {
        profileFile = File(res.files.first.path!);
      });
    }
  }

  void save(Community community) {
    ref.read(communityControllerProvider.notifier).editCommunity(
          profileFile: profileFile,
          bannerFile: bannerFile,
          context: context,
          community: community,
        );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(communityControllerProvider);

    return ref.read(getCommunityByNameProvider(widget.communityName)).when(
        data: (community) => Scaffold(
              appBar: AppBar(
                title: const Text('Edit Community'),
                actions: [
                  TextButton(
                    onPressed: () => save(community),
                    child: const Text(
                      'Save',
                      style: TextStyle(color: Colors.blue),
                    ),
                  )
                ],
              ),
              body: isLoading
                  ? const Loader()
                  : Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SizedBox(
                        height: 200,
                        child: Stack(
                          children: [
                            GestureDetector(
                              onTap: () => selectBannerImage(),
                              child: DottedBorder(
                                borderType: BorderType.RRect,
                                radius: const Radius.circular(10),
                                dashPattern: const [10, 4],
                                strokeCap: StrokeCap.round,
                                color: Pallete.darkModeAppTheme.textTheme
                                    .bodyMedium!.color!,
                                child: Container(
                                    width: double.infinity,
                                    height: 150,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: bannerFile != null
                                        ? Image.file(bannerFile!)
                                        : (community.banner.isEmpty ||
                                                community.banner ==
                                                    Constants.bannerDefault)
                                            ? const Center(
                                                child: Icon(
                                                  Icons.camera_alt_outlined,
                                                  size: 40,
                                                ),
                                              )
                                            : Image.network(community.banner)),
                              ),
                            ),
                            Positioned(
                              bottom: 20,
                              left: 20,
                              child: GestureDetector(
                                onTap: () => selectProfileImage(),
                                child: profileFile != null
                                    ? CircleAvatar(
                                        backgroundImage:
                                            FileImage(profileFile!),
                                        radius: 32,
                                      )
                                    : CircleAvatar(
                                        backgroundImage:
                                            NetworkImage(community.avatar),
                                        radius: 32,
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
        error: ((error, stackTrace) => ErrorText(error: error.toString())),
        loading: () => const Loader());
  }
}
