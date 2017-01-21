import { Component } from '@angular/core';

import { NavController } from 'ionic-angular';
import {RedditService} from '../../app/services/reddits.service';
import {DetailsPage} from '../detils/details';
@Component({
  selector: 'page-sample',
  templateUrl: 'sample.html'
})
export class samplePage {
items:any;
category:any;
limit:any;
  constructor(public navCtrl: NavController,private redditservice:RedditService) {
this.getDefaults();
  }
ngOnInit(){
this.getPost{this.category,this.limit};
}

getDefaults(){
if(localStorage.getItem('category')!=null){
this.category = localStorage.grtItem('category');
}else{
this.category='news';

}
if(localStorage.getItem('limit')!=null){
this.limit = localStorage.grtItem('limit');
}else{
this.limit = 10;
}
}


getPosts(category,limit){
this.redditservice.getPosts(category,limit).subscribe(response=>{
this.items =response.data.children ;
}
}

}
viewItem(item){
this.navCtrl.push(DetailsPage,{
item:item
}
changeCategory(){

}
}
