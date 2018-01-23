//
//  Header.h
//  VivreABerlin
//
//  Created by home on 28/04/17.
//  Copyright © 2017 Stoica Mihail. All rights reserved.
//

#ifndef Header_h
#define Header_h


// CHANGE EVERYTHING THAT HAS BERLIN IN IT. KEEP THE FORMAT . EX: Berlin.png -> Munich.png


// SIDEBAR
#define sideMenuLink  @"https://vivreaberlin.com/wp-json/menu-locations/primary"
#define colorsInSideBar  [NSArray arrayWithObjects:@"LeaveThisOneAndEditTheOthers",@"F18D12",@"69B7DC",@"ADBBE3",@"FAC925",@"F1638B",@"A2601D",@"829B00",@"B4CA35", nil]
#define adminAjax @"https://vivreaberlin.com/wp-admin/admin-ajax.php"


// IF THE APP DOESN"T HAVE ONE OF THIS SOCIAL JUST LEAVE THE @"" EMPTY
#define facebookSocial @"https://www.facebook.com/Vivre%C3%80Berlincom-156287077733704/?ref=ts"
#define twitterSocial @"https://twitter.com/VivreaBERLIN"
#define instagramSocial @"https://www.instagram.com/vivre.a.berlin/"
#define tumblrSocial @"https://vivreaberlin.tumblr.com/"


// CREDITS
#define ContactsetCredits @"https://vivreaberlin.com/contacts-et-credits"
#define Mentionslegales @"https://vivreaberlin.com/mentions-legales"
#define PartenairesPub @"https://vivreaberlin.com/partenaires-et-publicite"
#define Quisommesnous @"https://vivreaberlin.com/qui-sommes-nous"

// HOMEPAGE
#define HomePageLink  @"https://vivreaberlin.com/wp-json/homepage"
#define AppName @"Berlin"
#define AppNameWithLowerCase @"berlin"
#define settingsData @"https://vivreaberlin.com/wp-json/settings-data"

// GLOBAL VARIABLES

#define nameOfTheCity  @"Berlin"
#define subscribeKey @"b2afccfa7a"

// POST DETAILS
#define postDetailLink @"https://vivreaberlin.com/wp-json/post-data/%@"

//Category
#define categoryAdsLink @"https://vivreaberlin.com/wp-json/ads/category/%@"
#define categoryLink @"https://vivreaberlin.com/wp-json/posts/category/%@?page=%@"
#define postsFromTag @"https://vivreaberlin.com/wp-json/posts/tag/%@?page=%@"

//Agenda
#define agendaLink @"https://vivreaberlin.com/wp-json/agenda-data"
#define dossierLink @"http://vivreaberlin.com/wp-json/topics"
#define travelAgendaLink @"https://vivreaberlin.com/travel-agenda/%@"

//Announces
#define petitesAnnonces @"https://vivreaberlin.com/wp-json/petites-annonces?page=%d"
#define petitesAnnoncesArticleView  @"https://vivreaberlin.com/wp-json/petites-annonces/%@"
#define searchPetitesAnnonces @"https://vivreaberlin.com/wp-json/petites-annonces/search/%@?page=%d"

//Tickets
#define getYourGuidePOI @"https://vivreaberlin.com/wp-json/get-your-guide/poi"
#define getYourGuideTour @"https://vivreaberlin.com/iframe/get-your-guide/poi"

// MAP
#define mapLink @"https://vivreaberlin.com/wp-json/map-data"
#define NordEastMarkerLong @"13.76312255859375"
#define NordEastMarkerLat @"52.69303188011483"
#define SouthWestMarkerLat @"52.3835746"
#define SouthWestMarkerLong @"13.120975899999962"


// IAP
#define IAPID @"39249328493284932"
#define facebookInterstitialID @"167997730311966_358154934629577"
#define googleInterstitialID @"ca-app-pub-5601513769658709/7611082391"
#endif /* Header_h */