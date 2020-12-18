// Completes in 6.608 seconds
// Was it 1884?
#include <string.h>
#include <stdio.h>
#include <stdlib.h>

#define P_IN int x, int y, int z, int w
#define P_ARGS x, y, z, w
#define N 40
#define loop_all(body) { \
  for (int x = 0; x < N; x++) \
    { \
      for (int y = 0; y < N; y++) \
        { \
          for (int z = 0; z < N; z++) \
            { \
              for (int w = 0; w < N; w++) \
                { \
                  (body);                       \
                } \
            } \
        } \
    } \
}
int pts[N][N][N][N];


int
n_in_range (P_IN)
{
  int in_range = 0;

  // Just iterate neighbors
  for (int ix = x - 1; ix < x + 2; ix++)
    {
      for (int iy = y - 1; iy < y + 2; iy++)
        {
          for (int iz = z - 1; iz < z + 2; iz++)
            {
              for (int iw = w - 1; iw < w + 2; iw++)
                {
                  int x_diff = abs (ix - x);
                  int y_diff = abs (iy - y);
                  int z_diff = abs (iz - z);
                  int w_diff = abs (iw - w);
                  int diff = x_diff + y_diff + z_diff + w_diff;
                  int active = 0b01 & pts[ix][iy][iz][iw];

                  if (active && diff > 0 && diff <= 4
                      && x_diff < 2 && y_diff < 2 && z_diff < 2 && w_diff < 2)
                    {
                      in_range++;
                    }
            }
            }
        }
    }

  return in_range;
}

int
two_in_range (P_IN)
{
  return 2 == n_in_range (P_ARGS);
}

int
three_in_range (P_IN)
{
  return 3 == n_in_range (P_ARGS);
}

int
next_trans (P_IN)
{
  if (0b01 & pts[x][y][z][w])
    {
      return two_in_range(P_ARGS) || three_in_range (P_ARGS);
    }
  else
    {
      return three_in_range (P_ARGS);
    }
}

void
trans ()
{
  for (int x = 2; x < N - 2; x++)
    {
      for (int y = 2; y < N - 2; y++)
        {
          for (int z = 2; z < N - 2; z++)
            {
              for (int w = 2; w < N - 2; w++)
                {
                  int next = next_trans (P_ARGS) << 1;
                  pts[x][y][z][w] |= next;
                }
            }
        }
    }

  for (int x = 2; x < N - 2; x++)
    {
      for (int y = 2; y < N - 2; y++)
        {
          for (int z = 2; z < N - 2; z++)
            {
              for (int w = 2; w < N - 2; w++)
                {
                  pts[x][y][z][w] >>= 1;
                }
            }
        }
    }
}

int
main (int argc, char *argv[])
{
  loop_all(pts[x][y][z][w] = 0)

  int m = N / 2;

  // Small sample set (848) - getting 848, woohoo
  /* pts[1 + m][0 + m][0 + m][0 + m] = 0b01; */
  /* pts[2 + m][1 + m][0 + m][0 + m] = 0b01; */
  /* pts[0 + m][2 + m][0 + m][0 + m] = 0b01; */
  /* pts[1 + m][2 + m][0 + m][0 + m] = 0b01; */
  /* pts[2 + m][2 + m][0 + m][0 + m] = 0b01; */

  // Large sample set (1884)
  pts[3 + m][0 + m][0 + m][0 + m] = 0b01;
  pts[7 + m][0 + m][0 + m][0 + m] = 0b01;

  pts[7 + m][1 + m][0 + m][0 + m] = 0b01;
  pts[5 + m][1 + m][0 + m][0 + m] = 0b01;
  pts[3 + m][1 + m][0 + m][0 + m] = 0b01;
  pts[2 + m][1 + m][0 + m][0 + m] = 0b01;

  pts[0 + m][2 + m][0 + m][0 + m] = 0b01;
  pts[1 + m][2 + m][0 + m][0 + m] = 0b01;
  pts[2 + m][2 + m][0 + m][0 + m] = 0b01;
  pts[5 + m][2 + m][0 + m][0 + m] = 0b01;

  pts[6 + m][4 + m][0 + m][0 + m] = 0b01;
  pts[4 + m][4 + m][0 + m][0 + m] = 0b01;
  pts[3 + m][4 + m][0 + m][0 + m] = 0b01;

  pts[6 + m][5 + m][0 + m][0 + m] = 0b01;
  pts[5 + m][5 + m][0 + m][0 + m] = 0b01;
  pts[4 + m][5 + m][0 + m][0 + m] = 0b01;
  pts[3 + m][5 + m][0 + m][0 + m] = 0b01;
  pts[1 + m][5 + m][0 + m][0 + m] = 0b01;

  pts[3 + m][6 + m][0 + m][0 + m] = 0b01;
  pts[4 + m][6 + m][0 + m][0 + m] = 0b01;
  pts[5 + m][6 + m][0 + m][0 + m] = 0b01;
  pts[6 + m][6 + m][0 + m][0 + m] = 0b01;

  pts[2 + m][7 + m][0 + m][0 + m] = 0b01;
  pts[3 + m][7 + m][0 + m][0 + m] = 0b01;
  pts[7 + m][7 + m][0 + m][0 + m] = 0b01;

  fprintf (stderr, "The val is: %d\n", pts[1 + m][0 + m][0 + m][0 + m]);
  fprintf (stderr, "in range: %d\n", n_in_range (m, m, m, m));

  int active = 0b01 & 0b11;
  fprintf (stderr, "active?: %d\n", active);

  for (int c = 0; c < 6; c++) trans ();

  int total_active = 0;

  loop_all({if (0b01 & pts[x][y][z][w]) { total_active++; }})

  fprintf (stderr, "total_active: %d\n", total_active);

  exit (EXIT_SUCCESS);
}
