import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';

import { AppRoutingModule, routingComponents } from './app-routing.module';
import { AppComponent } from './app.component';
import { AdminNavBarComponent } from './Components/admin-nav-bar/admin-nav-bar.component';
import { FooterComponent } from './Components/footer/footer.component';
import {FormsModule} from "@angular/forms";
import { UploadComponent } from './upload/upload.component';
import { HttpClientModule } from '@angular/common/http';
import { DownloadComponent } from './download/download.component';




@NgModule({
  declarations: [
    AppComponent,
    routingComponents,
    AdminNavBarComponent,
    FooterComponent,
    UploadComponent,
    DownloadComponent,
  ],
    imports: [
        BrowserModule,
        AppRoutingModule,
        FormsModule,
        HttpClientModule
    ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }
