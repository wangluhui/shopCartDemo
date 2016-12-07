# shopCartDemo

如果是UICollectionView，要获取cell中view相对屏幕的frame的方法为:
// imageView为目标view，cell的subView; cell为UICollectionViewCell;
CGRect imageVRect = [cell convertRect:imageView.frame toView:cell];
CGRect realRect = [cell convertRect:imageVRect toView:self.view];


加入购物车的动画效果:
  ![GIF](https://github.com/wangluhui/image/raw/master/shopList.gif)
