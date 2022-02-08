import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/models/shop_favourites_model.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/cubit/shop_home_cubit/home_cubit.dart';
import 'package:shop_app/shared/cubit/shop_home_cubit/home_states.dart';
import 'package:shop_app/shared/styles/colors.dart';
class FavouritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return ConditionalBuilder(
          condition: state is! ShopGetFavouritesLoadingState,
          builder: (context) => ListView.separated(
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) => buildFavItem(
                HomeCubit.get(context)
                    .favoritesModel
                    .data
                    .data[index]
                    .product,
                context),
            separatorBuilder: (context, index) =>
                buildDivider(color: Colors.grey),
            itemCount:
            HomeCubit.get(context).favoritesModel.data.data.length,
          ),
          fallback: (context) => Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Widget buildFavItem(Product model, context) => Padding(
    padding: const EdgeInsets.all(20),
    child: Container(
      height: 120,
      child: Row(
        children: [
          Stack(alignment: AlignmentDirectional.bottomStart, children: [
            Image(
              height: 120,
              image: NetworkImage(model.image),
              width: 120,
            ),
            if (model.discount != 0)
              Container(
                color: Colors.red,
                child: Text(
                  "Discount",
                  style: TextStyle(color: Colors.white),
                ),
              )
          ]),
          SizedBox(
            width: 15,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  model.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(height: 1.2),
                ),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "${model.price.round()}",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 12, color: defaultColor),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    if (model.discount != 0)
                      Text(
                        "${model.oldPrice.round()}",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 10,
                            decoration: TextDecoration.lineThrough),
                      ),
                    Spacer(),
                    IconButton(
                        icon: CircleAvatar(
                          radius: 15,
                          backgroundColor:
                          HomeCubit.get(context).favourites[model.id]
                              ? defaultColor
                              : Colors.grey,
                          child: Icon(
                            Icons.favorite_border,
                            size: 14,
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () {
                          HomeCubit.get(context).changeFavourite(model.id);
                        })
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
