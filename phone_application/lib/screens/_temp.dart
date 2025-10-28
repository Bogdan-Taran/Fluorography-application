Future<void> addToFav({
  required int productId,
  required int index,
  VoidCallback? onAdded,
  VoidCallback? onRemoved,
}) async {
  var url =
      '${Constants.API_URL_DOMAIN}action=favorite_toggle&token=${Constants
      .USER_TOKEN}&product_id=$productId';
  http.Response response = await http.get(
    Uri.parse(url),
  );
  dynamic body = jsonDecode(response.body);
  print(body['success']);
  print(body['message']);
  if (body['message'] == 'ADDED') {
    onAdded?.call();
  } else {
    onRemoved?.call();
  }
}

ElevatedButton
(
onPressed: () {
addToFav(
index: index,
productId: productId,
onAdded: () {
setState(() => _isFavLoading.add(index));
},
onRemoved: () {
setState(() {
_isFavLoading.remove(index);
isFavorite = false;
});
},
);
},
child: Text('Fav'),
)
