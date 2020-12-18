// Completes in 0.049
#include <string.h>
#include <stdio.h>
#include <stdlib.h>

#define N 40
int pts[N][N][N];

int
n_in_range (int x, int y, int z)
{
  int in_range = 0;

  // Just iterate neighbors
  for (int ix = x - 1; ix < x + 2; ix++)
    {
      for (int iy = y - 1; iy < y + 2; iy++)
        {
          for (int iz = z - 1; iz < z + 2; iz++)
            {
              int x_diff = abs (ix - x);
              int y_diff = abs (iy - y);
              int z_diff = abs (iz - z);
              int diff = x_diff + y_diff + z_diff;
              int active = 0b01 & pts[ix][iy][iz];

              if (active && diff > 0 && diff <= 3 && x_diff < 2 && y_diff < 2 && z_diff < 2)
                {
                  in_range++;
                }
            }
        }
    }

  return in_range;
}

int
two_in_range (int x, int y, int z)
{
  return 2 == n_in_range (x, y, z);
}

int
three_in_range (int x, int y, int z)
{
  return 3 == n_in_range (x, y, z);
}

int
next_trans (int x, int y, int z)
{
  if (0b01 & pts[x][y][z])
    {
      return two_in_range(x, y, z) || three_in_range (x, y, z);
    }
  else
    {
      return three_in_range (x, y, z);
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
              int next = next_trans (x, y, z) << 1;
              pts[x][y][z] |= next;
            }
        }
    }

  for (int x = 2; x < N - 2; x++)
    {
      for (int y = 2; y < N - 2; y++)
        {
          for (int z = 2; z < N - 2; z++)
            {
              pts[x][y][z] >>= 1;
            }
        }
    }
}

int
main (int argc, char *argv[])
{
  for (int x = 0; x < N; x++)
    {
      for (int y = 0; y < N; y++)
        {
          for (int z = 0; z < N; z++)
            {
              pts[x][y][z] = 0;
            }
        }
    }

  int m = N / 2;

  pts[1 + m][0 + m][0 + m] = 0b01;
  pts[2 + m][1 + m][0 + m] = 0b01;
  pts[0 + m][2 + m][0 + m] = 0b01;
  pts[1 + m][2 + m][0 + m] = 0b01;
  pts[2 + m][2 + m][0 + m] = 0b01;

  fprintf (stderr, "The val is: %d\n", pts[1 + m][0 + m][0 + m]);
  fprintf (stderr, "in range: %d\n", n_in_range (m, m, m));

  int active = 0b01 & 0b11;
  fprintf (stderr, "active?: %d\n", active);

  for (int c = 0; c < 6; c++) trans ();

  int total_active = 0;

  for (int x = 0; x < N; x++)
    {
      for (int y = 0; y < N; y++)
        {
          for (int z = 0; z < N; z++)
            {
              if (0b01 & pts[x][y][z]) {
                total_active++;
              }
            }
        }
    }

  fprintf (stderr, "total_active: %d\n", total_active);

  exit (EXIT_SUCCESS);
}
