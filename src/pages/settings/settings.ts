import { Component } from '@angular/core';

import { NavController } from 'ionic-angular';
import {RedditService} from '../../app/services/reddits.service';
import {SamplePage} from '../sample/sample';
@Component({
  selector: 'settings',
  templateUrl: 'settings.html'
})
export class SettingsPage {

category:any;
limit:any;
  constructor(public navCtrl: NavController,private redditservice:RedditService) {
this.getDefaults();
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
setDefaults(){
localStorage.setItem('category',this.category);
localStorage.setItem('limit',this.limit);
this.navCtrl.push(SamplePage);
}
}
