import matplotlib.pyplot as plt
import numpy as np

x, y = np.loadtxt('results.txt', delimiter=',', unpack=True, dtype=type)
plt.plot(x,y, label='Loaded from file!')

#plt.xlabel('x')
#plt.ylabel('y')
plt.title('Interesting Graph\nCheck it out')
plt.plot(x, color="blue", linewidth=2.5, linestyle="-")
plt.plot(y, color="red",  linewidth=2.5, linestyle="-")
plt.legend()
plt.show()
