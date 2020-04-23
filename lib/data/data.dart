class SliderModel {
  String imgpath;
  String title;
  String des;

  SliderModel({this.imgpath, this.title, this.des});

  void setImagePath(String getImg) {
    imgpath = getImg;
  }

  void setTitle(String getTitle) {
    title = getTitle;
  }

  void setDes(String getDes) {
    des = getDes;
  }

  String setImagePath1() {
    return imgpath;
  }

  String setTitle1() {
    return title;
  }

  String setDes1() {
    return des;
  }
}

List<SliderModel> getSlide() {
  List<SliderModel> slides = new List<SliderModel>();
  SliderModel sliderM = new SliderModel();
  //1
  sliderM.setImagePath('images/loginbg.png');
  sliderM.setTitle('Acrivities');
  sliderM
      .setDes('Select your activity, Select the Time and Select the Location');
  slides.add(sliderM);
  sliderM = new SliderModel();
  //2
  sliderM.setImagePath('images/loginbg.png');
  sliderM.setTitle('Broadcast Activity');
  sliderM.setDes('Your event is broadcast to the Chalo Community');
  slides.add(sliderM);
  sliderM = new SliderModel();
  //3
  sliderM.setImagePath('images/loginbg.png');
  sliderM.setTitle('Enjoy your Activity');
  sliderM.setDes(
      'Enjoy your Activity when someone accepts and the activity begins!!');
  slides.add(sliderM);
  return slides;
}
