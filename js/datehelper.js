export function getDateOfWeek(w) {
    let d = (1 + (w - 1) * 7)-1; // 1st of January + 7 days for each week
    if (w==1) {d = 1;}
    const monDate = new Date(2019, 0, d);
    const sunDate = new Date(2019, 0, d + 6);
    return [monDate.getMonth() + 1, monDate.getDate(), sunDate.getMonth() + 1, sunDate.getDate()];
  }
  
  export function getMonthName(m) {
    switch (m) {
      case 1:
        return "ledna";
      case 2:
        return "února";
      case 3:
        return "března";
      case 4:
        return "dubna";
      case 5:
        return "května";
      case 6:
        return "června";
      case 7:
        return "července";
      case 8:
        return "srpna";
      case 9:
        return "září";
      case 10:
        return "října";
      case 11:
        return "listopadu";
      case 12:
        return "prosince";
      default:
        return m;
    }
  }
  
  export function getDateText(weekNumber) {
    const dates = getDateOfWeek(weekNumber);
  
    if (dates[0] === dates[2]) {
      return `${dates[1]}. - ${dates[3]}. ${getMonthName(dates[0])}`;
    }
  
    return `${dates[1]}. ${getMonthName(dates[0])} - ${dates[3]}. ${getMonthName(dates[2])}`;
  }
  
  export default { getDateText };