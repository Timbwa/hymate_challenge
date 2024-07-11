// ignore_for_file: public_member_api_docs

/// Currently available Bidding Zones
enum BiddingZone {
  austria(name: 'Austria', abbreviation: 'AT'),
  belgium(name: 'Belgium', abbreviation: 'BE'),
  switzerland(name: 'Switzerland', abbreviation: 'CH'),
  czechRepublic(name: 'Czech Republic', abbreviation: 'CZ'),
  germanyLuxembourg(name: 'Germany, Luxembourg', abbreviation: 'DE-LU'),
  germanyAustriaLuxembourg(name: 'Germany, Austria, Luxembourg', abbreviation: 'DE-AT-LU'),
  denmark1(name: 'Denmark 1', abbreviation: 'DK1'),
  denmark2(name: 'Denmark 2', abbreviation: 'DK2'),
  france(name: 'France', abbreviation: 'FR'),
  hungary(name: 'Hungary', abbreviation: 'HU'),
  italyNorth(name: 'Italy North', abbreviation: 'IT-North'),
  netherlands(name: 'Netherlands', abbreviation: 'NL'),
  norway2(name: 'Norway 2', abbreviation: 'NO2'),
  poland(name: 'Poland', abbreviation: 'PL'),
  sweden4(name: 'Sweden 4', abbreviation: 'SE4'),
  slovenia(name: 'Slovenia', abbreviation: 'SI');

  const BiddingZone({
    required this.name,
    required this.abbreviation,
  });

  final String name;
  final String abbreviation;
}
