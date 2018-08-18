import java.util.*;
import java.io.*;

public static final String dataDirectory = "/Users/surao/Desktop/root/dev/github/huffman/data/";
public static final String inputFilepath = dataDirectory + "mobydick.txt";
public static final String outputFilepathBase = dataDirectory;
public static final boolean log = true;

public void setup() {
    ArrayList<String> lines = new ArrayList<String>(Arrays.asList(loadStrings(inputFilepath)));
    HashMap<Byte, Integer> frequencyMap = buildFrequencyMap(lines);
    PriorityQueue<Node> pqueue = buildQueue(frequencyMap); 
    Node root = buildHuffmanTree(pqueue);
    HashMap<Byte, String> binaryMap = buildBinaryMap(root);
    ArrayList<String> encodedLines = encodeData(binaryMap, lines);
    logData(encodedLines);
    writeEncodedData(encodedLines, frequencyMap, binaryMap);
}

public void logData(ArrayList<String> encodedLines) {
    if (!log) return;
    println("Binary encoding: \n" + encodedLines);
    println("Total reductions: " + countReductions(encodedLines));
    println("Reduction rate: " + (double)countReductions(encodedLines)/encodedLines.size());    
}

public PriorityQueue<Node> buildQueue(HashMap<Byte, Integer> map) {
    PriorityQueue<Node> pqueue = new PriorityQueue<Node>();
    for (HashMap.Entry<Byte, Integer> entry : map.entrySet()) {
        Node node = new Node(entry.getKey(), entry.getValue());
        pqueue.add(node);
    }
    return pqueue;
}

public Node buildHuffmanTree(PriorityQueue<Node> pqueue) {
    Node root = null;
    while (!pqueue.isEmpty()) {
        Node left = null, right = null;
        int value = 0;
        try {
            left = pqueue.remove();
            right = pqueue.remove();
        } catch (NoSuchElementException e) {}

        if (left != null) value += left.getValue();
        if (right != null) value += right.getValue();

        Node parent = new Node(value);
        parent.setLeft(left);
        parent.setRight(right);
        if (pqueue.isEmpty()) {
            return parent;
        } 
        pqueue.add(parent);
        pqueue.remove(left);
        pqueue.remove(right);
    }
    return root;
}

public HashMap<Byte, Integer> buildFrequencyMap(ArrayList<String> lines) {
    HashMap<Byte, Integer> frequencyMap = new HashMap<Byte, Integer>();
    for (String line : lines) {
        try {
            byte[] bytes = line.getBytes("UTF-8");
            for (byte b : bytes) {
                if (frequencyMap.containsKey(b)) {
                    Integer value = frequencyMap.get(b);
                    if (value != null) {
                        frequencyMap.put(b, value+1);
                    }
                } else {
                    frequencyMap.put(b, 1);
                }
            }
        } catch (UnsupportedEncodingException e) { exit(); }
    }
    return frequencyMap;
}

public HashMap<Byte, String> buildBinaryMap(Node node) {
    return buildBinaryMap(node, "");
}

public HashMap<Byte, String> buildBinaryMap(Node node, String encoding) {
    HashMap<Byte, String> binaryMap = new HashMap<Byte, String>();
    if (node != null) {
        if (node.getLeft() == null && node.getRight() == null) {
            binaryMap.put(node.getData(), encoding);
        }

        binaryMap.putAll(buildBinaryMap(node.getLeft(), encoding + "0"));
        binaryMap.putAll(buildBinaryMap(node.getRight(), encoding + "1"));
    }
    return binaryMap;
}

public ArrayList<String> encodeData(HashMap<Byte, String> binaryMap, ArrayList<String> lines) {
    ArrayList<String> output = new ArrayList<String>();
    for (String line : lines) {
        try {
            byte[] bytes = line.getBytes("UTF-8");
            for (byte b : bytes) {
                output.add(binaryMap.get(b));
            }
        } catch (UnsupportedEncodingException e) { exit(); }
    }
    return output;
}

private static byte[] encodeToByteArray(int[] bits) {
    int numBytes = (bits.length + 7) / 8;
    byte[] results = new byte[numBytes];
    int byteValue = 0;
    int index;
    for (index = 0; index < bits.length; index++) {
        byteValue = (byteValue << 1) | bits[index];
        if (index % 8 == 7) {
            results[index / 8] = (byte)byteValue;
        }
    }

    if (index % 8 != 0) {
        results[index / 8] = (byte) (byteValue << (8 - (index % 8)));
    }
    return results;
}

public static final String separator = ":::";
public static final String terminator = "(Definitive^Terminator%Register*Index)\n";
public ArrayList<String> formatFrequencyMap(HashMap<Byte, Integer> map, HashMap<Byte, String> binaryMap) {
    ArrayList<String> formattedLines = new ArrayList<String>();
    for (HashMap.Entry<Byte, Integer> entry : map.entrySet()) {
        Byte b = entry.getKey();
        Integer i = entry.getValue();
        String formattedEntry = b.toString() + separator + i.toString() + "\n";
        formattedLines.add(formattedEntry);
    }
    formattedLines.add(terminator);
    return encodeData(binaryMap, formattedLines);
}

public static final String kFileNotFoundError = "The file could not be found, nor created.";
public static final String kInputOutputError = "The program could not write to the file.";
public void writeEncodedData(ArrayList<String> encodedBytes, HashMap<Byte, Integer> frequencyMap, HashMap<Byte, String> binaryMap) {
    long now = System.nanoTime();
    String time = Long.toString(now);
    String outputFilepath = outputFilepathBase + Math.abs(time.hashCode());
    try { 
        File outputFile = new File(outputFilepath);
        if (!outputFile.exists()) outputFile.createNewFile();
        FileOutputStream outputStream = new FileOutputStream(outputFile, true);
        
        ArrayList<String> frequencyMapBytes = formatFrequencyMap(frequencyMap, binaryMap);
        String byteString = String.join("", frequencyMapBytes) + String.join("", encodedBytes);
        int[] fragmentedBytes = new int[byteString.length()];
        int index = 0;
        for (char ch : byteString.toCharArray()) {
            fragmentedBytes[index++] = ch == '1' ? 1 : 0;
        }
        
        byte[] bitmaskedBytes = encodeToByteArray(fragmentedBytes);
        outputStream.write(bitmaskedBytes);
        outputStream.close();
    } catch (FileNotFoundException e) { println(kFileNotFoundError); 
    } catch (IOException e) { println(kInputOutputError); } 
}

public static final String kDefaultInputFilepath = dataDirectory + "input/";
public static final String kInputFileNotFoundError = "Input file could not be found.";
public void readEncodedData() {
    File input = new File(kDefaultInputFilepath);
    if (!input.exists()) {
        println(kInputFileNotFoundError); 
        exit(1);
    }
}

public int countReductions(ArrayList<String> encodedBytes) {
    int reductions = 0;
    for (String line : encodedBytes) {
        if (line.length() < 8) reductions++;
    }
    return reductions;
}

public void printBinaryMap(HashMap<Byte, String> map) {
    for (HashMap.Entry<Byte, String> entry : map.entrySet()) {
        Byte b = entry.getKey();
        String s = entry.getValue();
        System.out.println("{" + b + " -> " + s + "}");
    }
}

public void printFrequencyMap(HashMap<Byte, Integer> map) {
    for (HashMap.Entry<Byte, Integer> entry : map.entrySet()) {
        Byte b = entry.getKey();
        Integer value = entry.getValue();
        System.out.println("{" + b.toString() + ", " + value.toString() + "}");
    }
}

public void printQueue(PriorityQueue<Node> pqueue) {
    Iterator it = pqueue.iterator();
    while (it.hasNext()) {
        System.out.println(it.next().toString());
    }
}
