import 'package:flutter/material.dart';

import 'custom_shimmer.dart';

class ShimmerLoading extends StatelessWidget {
  final bool? detail, home, homeA, foodCard, search, favorite, profile;
  const ShimmerLoading(
      {Key? key,
      this.detail,
      this.home,
      this.homeA,
      this.foodCard,
      this.search,
      this.favorite,
      this.profile})
      : super(key: key);

  Widget foodCardShimmer(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 7,
          child: CustomShimmer.rectangular(
            height: MediaQuery.of(context).size.height * 0.24,
            // width: MediaQuery.of(context).size.width * 0.3,
          ),
        ),
        const Expanded(
          flex: 1,
          child: SizedBox(
              // width: 5,
              ),
        ),
        Expanded(
          flex: 5,
          child: CustomShimmer.circular(
            height: MediaQuery.of(context).size.height * 0.24,
            // width: MediaQuery.of(context).size.width * 0.3,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (detail!) {
      return Padding(
        padding: const EdgeInsets.only(left: 8, right: 8),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomShimmer.rectangular(
                width: MediaQuery.of(context).size.height * 1,
                height: MediaQuery.of(context).size.width * 0.4,
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomShimmer.rectangular(
                    height: MediaQuery.of(context).size.height * 0.05,
                    width: MediaQuery.of(context).size.width * 0.3,
                  ),
                  CustomShimmer.rectangular(
                    height: MediaQuery.of(context).size.height * 0.05,
                    width: MediaQuery.of(context).size.width * 0.3,
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              CustomShimmer.rectangular(
                height: MediaQuery.of(context).size.height * 0.15,
                width: MediaQuery.of(context).size.width * 1,
              ),
              const SizedBox(
                height: 10,
              ),
              CustomShimmer.rectangular(
                height: MediaQuery.of(context).size.height * 0.15,
                width: MediaQuery.of(context).size.width * 1,
              ),
              const SizedBox(
                height: 10,
              ),
              CustomShimmer.rectangular(
                height: MediaQuery.of(context).size.height * 0.05,
                width: MediaQuery.of(context).size.width * 1,
              ),
              const SizedBox(
                height: 15,
              ),
              foodCardShimmer(context)
            ],
          ),
        ),
      );
    }
    if (home!) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.35,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomShimmer.rectangular(
                        height: MediaQuery.of(context).size.height * 0.2,
                        width: MediaQuery.of(context).size.width * 0.5,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      CustomShimmer.rectangular(
                        height: MediaQuery.of(context).size.height * 0.03,
                        width: MediaQuery.of(context).size.width * 0.1,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      CustomShimmer.rectangular(
                        height: MediaQuery.of(context).size.height * 0.02,
                        width: MediaQuery.of(context).size.width * 0.2,
                      ),
                    ],
                  ),
                );
              },
              itemCount: 3),
        ),
      );
    }
    if (homeA!) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.35,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomShimmer.rectangular(
                        height: MediaQuery.of(context).size.height * 0.03,
                        width: MediaQuery.of(context).size.width * 0.1,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      CustomShimmer.rectangular(
                        height: MediaQuery.of(context).size.height * 0.15,
                        width: MediaQuery.of(context).size.width * 0.5,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      CustomShimmer.rectangular(
                        height: MediaQuery.of(context).size.height * 0.02,
                        width: MediaQuery.of(context).size.width * 0.2,
                      ),
                    ],
                  ),
                );
              },
              itemCount: 3),
        ),
      );
    }
    if (search!) {
      return ListView.builder(
          shrinkWrap: true,
          itemCount: 5,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(left: 2, right: 2, top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: CustomShimmer.circular(
                      height: MediaQuery.of(context).size.height * 0.1,
                      // width: MediaQuery.of(context).size.width * 0.2,
                    ),
                  ),
                  Expanded(
                      child: Column(
                    children: [
                      CustomShimmer.rectangular(
                        height: MediaQuery.of(context).size.height * 0.03,
                        // width: MediaQuery.of(context).size.width * 0.2,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      CustomShimmer.rectangular(
                        height: MediaQuery.of(context).size.height * 0.07,
                        // width: MediaQuery.of(context).size.width * 0.2,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      CustomShimmer.rectangular(
                        height: MediaQuery.of(context).size.height * 0.01,
                        // width: MediaQuery.of(context).size.width * 0.2,
                      ),
                    ],
                  )),
                  Expanded(
                      child: Center(
                    child: CustomShimmer.circular(
                      height: MediaQuery.of(context).size.height * 0.1,
                      width: MediaQuery.of(context).size.width * 0.1,
                    ),
                  ))
                ],
              ),
            );
          });
    }
    if (favorite!) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 1,
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: 5,
            itemBuilder: (context, index) {
              return ListTile(
                leading: CustomShimmer.circular(
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: MediaQuery.of(context).size.width * 0.1,
                ),
                title: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: CustomShimmer.rectangular(
                        height: MediaQuery.of(context).size.height * 0.02,
                        // width: MediaQuery.of(context).size.width * 0.005,
                      ),
                    ),
                    Expanded(flex: 2, child: Container())
                  ],
                ),
                subtitle: CustomShimmer.rectangular(
                  height: MediaQuery.of(context).size.height * 0.03,
                  width: MediaQuery.of(context).size.width * 0.07,
                ),
                trailing: CustomShimmer.circular(
                  height: MediaQuery.of(context).size.height * 0.06,
                  width: MediaQuery.of(context).size.width * 0.06,
                ),
              );
            }),
      );
    }
    if (profile!) {
      return ListView(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomShimmer.rectangular(
                  height: MediaQuery.of(context).size.height * 0.05,
                  width: MediaQuery.of(context).size.width * 0.2,
                ),
                const SizedBox(
                  height: 15,
                ),
                CustomShimmer.rectangular(
                  height: MediaQuery.of(context).size.height * 0.04,
                  width: MediaQuery.of(context).size.width * 0.8,
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomShimmer.rectangular(
                  height: MediaQuery.of(context).size.height * 0.04,
                  width: MediaQuery.of(context).size.width * 0.8,
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomShimmer.rectangular(
                  height: MediaQuery.of(context).size.height * 0.04,
                  width: MediaQuery.of(context).size.width * 0.8,
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomShimmer.rectangular(
                  height: MediaQuery.of(context).size.height * 0.04,
                  width: MediaQuery.of(context).size.width * 0.8,
                ),
              ],
            ),
          ),
        ],
      );
    }
    if (foodCard!) {
      return Column(
        children: [
          const SizedBox(
            height: 70,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 7,
                  child: CustomShimmer.rectangular(
                    height: MediaQuery.of(context).size.height * 0.20,
                    // width: MediaQuery.of(context).size.width * 0.3,
                  ),
                ),
                const Expanded(
                  flex: 1,
                  child: SizedBox(
                      // width: 5,
                      ),
                ),
                Expanded(
                  flex: 5,
                  child: CustomShimmer.circular(
                    height: MediaQuery.of(context).size.height * 0.24,
                    // width: MediaQuery.of(context).size.width * 0.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }
    return Container();
  }
}
