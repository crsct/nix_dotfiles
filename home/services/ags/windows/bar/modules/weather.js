import { Widget } from "../../../imports.js";

// 03ec2b7de8759b5d126a097c99029033
// curl "http://api.openweathermap.org/geo/1.0/direct?q=hungen,DE&limit=5&appid=03ec2b7de8759b5d126a097c99029033"
// [{"name":"Hungen","local_names":{"fa":"هونگن","ru":"Хунген","zh":"洪根","de":"Hungen"},"lat":50.4696168,"lon":8.9171014,"country":"DE","state":"Hesse"},{"name":"Hungen","lat":50.485874100000004,"lon":8.901645243222704,"country":"DE","state":"Hesse"},{"name":"Hungen","local_names":{"ru":"Хунг
export default () =>
  Widget.Icon({ className: "weather module" }).bind(
    "icon",
    Weather,
    "connected-devices",
    getBluetoothIcon,
  );
