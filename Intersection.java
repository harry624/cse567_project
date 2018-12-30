import java.io.*;

public class Intersection {

	public static void main (String[] args) throws IOException {

		String fileName = args[0];
		//	BufferedReader d = new BufferedReader(new InputStreamReader(new FileInputStream(new File (fileName))));
		//                OutputStreamWriter out = new OutputStreamWriter (new FileOutputStream(fileName+".1"), "UTF-8");
		BufferedReader d1;
		d1 = new BufferedReader(new InputStreamReader(new FileInputStream(new File(fileName))));

		String fileName2 = args[1];
		BufferedReader d2; 
		d2 = new BufferedReader(new InputStreamReader(new FileInputStream(new File(fileName2))));

		String str1 = new String(); 
		String str2 = new String();
		str1 = d1.readLine(); 
		str2 = d2.readLine();

		String[]  ar = new String[2048];
		int id = 0; 
		boolean flag = true; 

		double count = 0; 

		while (str1 != null && str2 !=null) {
			str1 = str1.trim(); str2 = str2.trim(); 

			if (str1.length()==0 && str2.length()==0) {
				double threshold = count/id; 
				//System.err.println(threshold); 
				if (threshold >= 0.2) flag = false; 
				else flag = true; 
				if (flag) {
					for (int i=0; i<id; i++) {
						System.out.println(ar[i]);
					}
					System.out.println();
				}
				else {}

				ar = new String[2048];
				id = 0; 
				flag = true; 
				count = 0; 
			}
			else {
				if (str1.contains("\t") && str2.contains("\t")) {
					String delim = "\t";
					String[] entry1;
					entry1 = str1.split(delim);
					String[] entry2;
					entry2 = str2.split(delim);

					// 4, 7, 8
					String line1 = entry1[3] + " " + entry1[6] + " " + entry1[7];
					String line2 = entry2[3] + " " + entry2[6] + " " + entry2[7]; 
					if (line1.equals(line2)) {}
					else { count++; }
				}
				ar[id] = str1; 
				id++;
			}
			str1 = d1.readLine(); str2 = d2.readLine(); 
		}
		d1.close(); d2.close();
	}
}

/*
   StringTokenizer st = new StringTokenizer(str, delim);
   while (st.hasMoreTokens()) {
   String tok = st.nextToken();
   }
 */
/*
   Enumeration k = hash.keys();
   while(k.hasMoreElements()) {
   String key = (String) k.nextElement();
   System.out.println(key + "\t" + hash.get(key));
   }
 */
