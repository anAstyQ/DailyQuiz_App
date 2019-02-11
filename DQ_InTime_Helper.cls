public class DQ_InTime_Helper {

    public static Boolean checkTimeliness(Datetime lastModifiedDate){
        if( Integer.valueOf(lastModifiedDate.format('hh')) == 10 && Integer.valueOf(lastModifiedDate.format('mm')) <= 30 && lastModifiedDate.format('a') == 'AM') {
            return true;
        } else if(Integer.valueOf(lastModifiedDate.format('hh')) < 10 && lastModifiedDate.format('a') == 'AM'){
        	return true;
        }else {
            return false;
        }   
    }
}