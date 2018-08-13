import java.util.Arrays;
import java.util.PriorityQueue;

public static final String dataDirectory = "/Users/surao/Desktop/root/dev/github/huffman/data/mobydick.txt";

public void setup() {
    Node root = null;
    ArrayList<String> lines = new ArrayList<String>(Arrays.asList(loadStrings(dataDirectory)));
    HashMap<Byte, Integer> frequencyMap = buildFrequencyMap(lines);
    printMap(frequencyMap);
    PriorityQueue<Node> pqueue = buildQueue(frequencyMap);
    while (!pqueue.isEmpty()) {
        Node b = pqueue.poll();
        System.out.println(b.toString());
    }
}

PriorityQueue<Node> buildQueue(HashMap<Byte, Integer> map) {
    PriorityQueue<Node> pqueue = new PriorityQueue<Node>();
    for(HashMap.Entry<Byte, Integer> entry : map.entrySet()) {
        Node node = new Node(entry.getKey(), entry.getValue());
        pqueue.add(node);
    }
    return pqueue;
}

public void printMap(HashMap<Byte, Integer> map) {
    for (HashMap.Entry<Byte, Integer> entry : map.entrySet()) {
        Byte key = entry.getKey();
        Integer value = entry.getValue();
        System.out.println("{" + key.toString() + ", " + value.toString() + "}");
    }
}

public HashMap<Byte, Integer> buildFrequencyMap(ArrayList<String> lines) {
    HashMap<Byte, Integer> frequencyMap = new HashMap<Byte, Integer>();
    for (String line : lines) {
        try {
            byte[] bytes = line.getBytes("UTF-8");
            for (byte b: bytes) {
                if (frequencyMap.containsKey(b)) {
                    Integer value = frequencyMap.get(b);
                    if (value != null) {
                        frequencyMap.put(b, value+1);
                    }
                } else {
                    frequencyMap.put(b, 1);
                }
            }
        } catch (Exception e) {}
    }
    return frequencyMap;
}

public void draw() {}
