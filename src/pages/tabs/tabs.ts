import { Component } from '@angular/core';

import { samplePage } from '../sample/sample';
import { AboutPage } from '../about/about';
import { settingsPage } from '../settings/settings';

@Component({
  templateUrl: 'tabs.html'
})
export class TabsPage {
  // this tells the tabs component which Pages
  // should be each tab's root Page
  tab1Root: any = samplePage;
  tab2Root: any = AboutPage;
  tab3Root: any = settingsPage;

  constructor() {

  }
}
