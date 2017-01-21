import { NgModule, ErrorHandler } from '@angular/core';
import { IonicApp, IonicModule, IonicErrorHandler } from 'ionic-angular';
import { MyApp } from './app.component';
import { AboutPage } from '../pages/about/about';
import { samplePage } from '../pages/sample/sample';
import { settingsPage } from '../pages/settings/settings';
import { TabsPage } from '../pages/tabs/tabs';
import {DetailsPage} from '../pages/details/details';
@NgModule({
  declarations: [
    MyApp,
    AboutPage,
    samplePage,
    settingsPage,
    TabsPage
    DetailsPage
  ],
  imports: [
    IonicModule.forRoot(MyApp)
  ],
  bootstrap: [IonicApp],
  entryComponents: [
    MyApp,
    AboutPage,
    samplePage,
    settingsPage,
    TabsPage
  ],
  providers: [{provide: ErrorHandler, useClass: IonicErrorHandler}]
})
export class AppModule {}
