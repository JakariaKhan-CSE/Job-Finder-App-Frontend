
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job_finder_app/controllers/bookmark_provider.dart';
import 'package:job_finder_app/controllers/job_provider.dart';
import 'package:job_finder_app/model/request/Bookmark/bookmark_request.dart';
import 'package:job_finder_app/model/request/Chat/create_chat.dart';
import 'package:job_finder_app/model/request/Message/send_message.dart';
import 'package:job_finder_app/services/helper/chat_helper.dart';
import 'package:job_finder_app/services/helper/messaging_helper.dart';
import 'package:job_finder_app/views/common/app_bar.dart';
import 'package:job_finder_app/views/common/reusable_text.dart';
import 'package:job_finder_app/views/ui/mainScreen.dart';
import 'package:provider/provider.dart';

class JobPage extends StatefulWidget {
  final String title;
  final String id;
  const JobPage({super.key, required this.title, required this.id});

  @override
  State<JobPage> createState() => _JobPageState();
}

class _JobPageState extends State<JobPage> {
  @override
  Widget build(BuildContext context) {
    final bookmarkNotifier = Provider.of<BookMarkNotifier>(context);
    bookmarkNotifier.loadJobs();
    return Consumer<JobNotifier>(
      builder: (context, jobNotifier, child) {
        // ai page open hoyar sathe sathe single job fetch kore niye ashbe
        jobNotifier.getJob(widget.id);
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: CustomAppbar(
              text: widget.title,
              actions: [
                GestureDetector(
                  onTap: () {
                    if (bookmarkNotifier.jobs.contains(widget.id)) {
                      bookmarkNotifier.deleteBookMark(widget.id);
                    } else {
                      BookmarkRequest model = BookmarkRequest(job: widget.id);
                      bookmarkNotifier.addBookMark(model, widget.id);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: !bookmarkNotifier.jobs.contains(widget.id)
                        ? const Icon(Icons.bookmark_outline)
                        : const Icon(Icons.bookmark),
                  ),
                )
              ],
              child: GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: const Icon(CupertinoIcons.arrow_left),
              ),
            ),
          ),
          body: FutureBuilder(
            // job variable er property access kora hosse
            future: jobNotifier.job,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error is: ${snapshot.error}'),
                );
              } else {
                // snapshot data ke job variable er vitore neya hosse
                final job = snapshot.data;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Stack(
                    children: [
                      ListView(
                        padding: EdgeInsets.zero,
                        children: [
                          const SizedBox(
                            height: 30,
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.27,
                            width: double.infinity,
                            color: Colors.grey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  backgroundImage: NetworkImage(job!.imageUrl),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                ReusableText(
                                    text: job.title,
                                    style: const TextStyle(
                                        fontSize: 22,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600)),
                                const SizedBox(
                                  height: 5,
                                ),
                                ReusableText(
                                    text: job.location,
                                    style: const TextStyle(
                                        fontSize: 22,
                                        color: Colors.blueGrey,
                                        fontWeight: FontWeight.normal)),
                                const SizedBox(
                                  height: 15,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      OutlinedButton(
                                          style: OutlinedButton.styleFrom(
                                            backgroundColor: Colors.white,
                                            foregroundColor: Colors.deepOrange,
                                          ),
                                          onPressed: () {},
                                          child: Text(job.period)),
                                      Row(
                                        children: [
                                          ReusableText(
                                              text: job.salary,
                                              style: const TextStyle(
                                                  fontSize: 22,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600)),
                                          const ReusableText(
                                              text: "/monthly",
                                              style: TextStyle(
                                                  fontSize: 22,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600)),
                                        ],
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const ReusableText(
                              text: "Job description",
                              style: TextStyle(
                                  fontSize: 22,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600)),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            job.description,
                            textAlign: TextAlign.justify,
                            maxLines: 8,
                            style: const TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                                fontWeight: FontWeight.normal),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const ReusableText(
                              text: "Requirements",
                              style: TextStyle(
                                  fontSize: 22,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600)),
                          const SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.6,
                            child: ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount:
                                  job.requirements.length, // requirement length
                              itemBuilder: (context, index) {
                                final req = job
                                    .requirements[index]; // single requirement
                                String bullet = "\u2022 ";

                                return Text(
                                  '$bullet $req\n',
                                  maxLines: 4,
                                  textAlign: TextAlign.justify,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold),
                                );
                              },
                            ),
                          )
                        ],
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.deepOrange,
                              foregroundColor: Colors.white),
                          onPressed: () {

                            // when click apply button automatically send a formal message to the agent
                            // then job seeker can chat with agent
                            // at first create chat using agent ID

                            CreateChat model = CreateChat(userId: job.agentId!);
                            //return [true, chatId];
                            Chathelper.apply(model).then((response){
                              if(response[0])
                                {
                                  // create send message model
                                  SendMessage model = SendMessage(
                                      content: "Hello, I am interested in ${job.title} job in ${job.location}",
                                      chatId: response[1],
                                      receiver: job.agentId!);

                                  // send message
                                  MessagingHelper.sendMessage(model).whenComplete((){ // very useful
                                    // when this operation complete. Navigate to other page
                                    Get.to(()=>const MainScreen());
                                  });
                                }
                            });
                          },
                          child: const Text('Apply Now'),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      )
                    ],
                  ),
                );
              }
            },
          ),
        );
      },
    );
  }
}
