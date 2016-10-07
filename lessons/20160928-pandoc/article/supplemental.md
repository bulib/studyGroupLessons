% Stage-discharge relationship in tidal channels: Supplemental Information

In this appendix, we present each of the models and the estimation procedure in more detail than in the main text.

We assume we have available to us two time series, a training and a test data set, of stage $\{h\}_{i=1}^{N_j}$ and discharge $\{Q\}_{i=1}^{N_j}$ for $j\in\{1,2\}$. Each of the models possesses a system order, $M$, which we will make more clear below in the description of the models. The system order represents how far back in time we need to look at stage in order to estimate discharge. For each value of discharge, we use the current value of stage and the $M-1$ previous values of stage in the estimation procedure. This leads to a design matrix of the form

\begin{equation}
H = \begin{bmatrix}
h_{M} & h_{M-1} & \hdots & h_1\\
h_{M+1} & h_{M} & \hdots & h_2\\
\vdots & \vdots & \ddots & \vdots\\
h_{N} & h_{N-1} & \hdots & h_{N-M+1}
\end{bmatrix}
\end{equation}

and we call the rows of the design matrix _stage trajectories_. We also form the corresponding vector of discharge values $\mathbf{Q} = \left[Q_M,Q_{M+1},\hdots,Q_N\right]^T$. Note that we cannot estimate the first $M-1$ discharges of the time series because we do not have a record of stage before time step 1. Note that when validating the hyperparameters of the model using cross-validation, the number of rows of the design matrix will be different as we will estimate the model only on the first half of the time series. $N$ in the above matrix therefore refers either to $N_1$, the length of the training data set, $N_2$, the length of the test data set, or $N_{CV}$, the length of the cross-validation portion of the training data set.

# Models

## Boon

The discrete version of the Boon model takes the form

\begin{equation}
Q_i = \alpha h_i^\beta \left(h_i-h_{i-1}\right)
\end{equation}

Because of the discrete derivative $h_i-h_{i-1}$ on the right-hand side, the order of the Boon model is 2. We solve the nonlinear least squares problem

\begin{equation}
\boldsymbol{\beta} = \argmin_{\boldsymbol{\beta}} \sum_{i=2}^N (Q_i-\alpha h_i^\beta \left(h_i-h_{i-1}\right))^2
\end{equation}

where the vector $\boldsymbol{\beta} = \left[\alpha,\beta\right]^T$. We use the gradient-free Nelder-Mead method provided in Julia's Optim.jl package to optimize the parameters $\alpha$ and $\beta$. We could very easily take the derivative of the least squares problem with respect to each of the parameters to find a gradient which we could then use in the Gauss-Newton method or any other optimization method.

## Linear, time-invariant

The linear, time-invariant model finds the least squares solution to the overdetermined linear system

\begin{equation}
H\boldsymbol{\beta} = \mathbf{Q}
\end{equation}

where $H$ and $\mathbf{Q}$ are the design matrix and discharge vector defined above. The solution to this problem is

\begin{equation}\label{unreg}
\hat{\boldsymbol{\beta}} = (H^TH)^{-1}H^T\mathbf{Q}
\end{equation}

but as noted in the main text, the matrix $H^TH$ tends to be very poorly conditioned, needing regularization. The solution to the $L_2$ regularization with parameter $\lambda$ is

\begin{equation}
(H^TH + \lambda I)^{-1}H^T\mathbf{Q}
\end{equation}

In either case, we avoid taking the inverse of the matrix $H^TH$ by using the singular value decomposition. We decompose the design matrix $H = U\Sigma V^T$ where $U$ and $V$ are matrices of left and right singular vectors and $\Sigma$ is a diagonal matrix of singular values, $\sigma_i$. The $L_2$-regularized solution can be written in terms of the singular value decomposition

\begin{equation}
\hat{\boldsymbol{\beta}} = VDU^T\mathbf{Q}
\end{equation}

with the diagonal matrix D such that

\begin{equation}
D_{ii} = \frac{\sigma_i}{\sigma_i^2+\lambda^2}
\end{equation}

When $\lambda=0$, the solution becomes that of the unregularized problem (Eq. \ref{unreg}).

## Volterra series

The Volterra series model is defined as

\begin{equation}
Q_i = F_0(\mathbf{h}_i) + F_1(\mathbf{h}_i) + F_2(\mathbf{h}_i) + \dots
\end{equation}

where the $k$-th order Volterra operator is

\begin{equation}\label{operator}
F_k(\mathbf{h}) = \sum_{i_1=1}^M \dots \sum_{i_k=1}^M f^{(k)}_{i_1\dots i_k}h_{i_1}\dots h_{i_k}
\end{equation}

Each $f^{(k)}$ is an $k$-th order tensor of size $M^k$ and the $\mathbf{h}_i$ are the $M$-dimensional rows of the design matrix. As mentioned in the main text, we estimate the $f^{(k)}$ up to a finite order $p$ by using the duality between the Volterra series and regression in a reproducing kernel Hilbert space. We write

\begin{equation}
Q = g(\mathbf{h}) = \sum_{j=M}^N \alpha_jk(\mathbf{h},\mathbf{h}_j)
\end{equation}

where $k(\mathbf{h}_1,\mathbf{h}_2)$ is a positive-definite kernel function which implements the projection of the stage into the space defined by the Volterra operators (Eq. \ref{operator}). Since the Volterra operators are a weighted sum of monomials of the input vector, the sensible kernel is a polynomial one

\begin{equation}
k(\mathbf{h}_1,\mathbf{h}_2) = \sum_{k=0}^p a_k^2(\mathbf{h}_1^T\mathbf{h}_2)^k
\end{equation}

where the ${a_k}_{k=0}^p$ are arbitrary weights. We can choose the weights $a_k^2 = {p \choose k}$ to obtain the inhomogeneous polynomial kernel

\begin{equation}
k(\mathbf{h}_1,\mathbf{h}_2) = (1+\mathbf{h}_1^T\mathbf{h}_2)^p = \sum_{k=0}^p {p \choose k} (\mathbf{h}_1^T\mathbf{h}_2)^n
\end{equation}

which we prefer for its simplicity.

In order to estimate the Volterra series model, we solve the equation

\begin{equation}
\hat{\boldsymbol{\alpha}} = K^{-1}\mathbf{Q}
\end{equation}

where

\begin{equation}
K_{ij} = k(\mathbf{h}_i,\mathbf{h}_j) = (1+\mathbf{h}_i^T\mathbf{h}_j)^p
\end{equation}

To estimate discharge for a new $M$-dimensional stage trajectory $\mathbf{h}$ one multiplies takes the dot product of the estimated coefficients and the kernel function applied to the new trajectory and each of the trajectories in the training data set

\begin{equation}
\hat{Q}(\mathbf{h}) = \hat{\boldsymbol{\alpha}}^T\mathbf{k}(\mathbf{h}) = \sum_{j=M}^N \hat{\alpha}_j k(\mathbf{h},\mathbf{h}_j)
\end{equation}

The Volterra operators, shown in Fig. 2 in the main text, can also be retrieved

\begin{equation}
F_k(\mathbf{h}) = a_k \sum_{j=M}^N \hat{\alpha}_j (\mathbf{h}_j^T\mathbf{h})^k
\end{equation}

We show only the first and second order operators in Fig. 2 because the zeroth order operator is a constant and higher-order operators are multidimensional tensors which are hard to visualize.

As in the linear, time-invariant model, the matrix $K$ is ill-conditioned, so we regularize by adding a multiple of the identity matrix to the Gram matrix

\begin{equation}
\hat{\boldsymbol{\alpha}} = (K+\lambda I)^{-1}\mathbf{Q}
\end{equation}

## k-means

The estimation of the k-means model proceeds identically to the linear, time-invariant with the change that $k$ different linear, time-invariant models are estimated. We interpret each row of the design matrix as a point in an $M$-dimensional space. We use k-means clustering to partition the space into $k$ clusters. Each cluster is defined as the set of points which are closer in the Euclidean metric to the center of that group, $\mathbf{c}_i$, than to the centers of the other $k-1$ cluster.  For each cluster, we collect the rows of the full design matrix into a separate design matrix and use the least squares solution above to estimate a linear, time-invariant model for the cluster, resulting in $k$ $M$-dimensional vectors $\boldsymbol{\beta}_i$ for $i\in \{1,\dots,k\}$. To estimate discharge for a new stage trajectory, $\mathbf{h}$, first calculate the Euclidean distance between $\mathbf{h}$ and each of the $k$ centers.

\begin{equation}
d_i^2 = \sum_{j=1}^M (h_j-c_{ij})^2
\end{equation}

where $h_j$ is the $j$-th element of the stage trajectory $\mathbf{h}$ and $c_{ij}$ is the $j$-th element of the $i$-th center $\mathbf{c}_i$. Choose the coefficient vector $\boldsymbol{\beta}_i$ with the smallest $d_i$ and estimate the discharge as in the linear, time-invariant model

\begin{equation}\label{k-means-Q}
\hat{Q}(\mathbf{h}) = \boldsymbol{\beta}_i^T\mathbf{h}
\end{equation}

## Threshold

The threshold model, our recommended model for simple but accurate discharge estimates, is estimated identically to the k-means model, but the clusters are not determined by the k-means algorithm but by an arbitrary threshold. We have found four clusters to be effective, though more clusters can easily be incorporated into the threshold model. The four clusters represent high flood tides, high ebb tides, low ebb tides and low flood tides. To make the distinction between flood and ebb tides, take the difference between the first and second elements of the $M$-dimensional stage trajectory ($h_1-h_2$). As long as the stage record is not too noisy, this difference is positive on the flood tide and negative on the ebb tide. If there is significant noise in the stage record, a smoothing procedure or a more robust way to determine the flood or ebb status is necessary. To make the distinction between high and low tides, a threshold elevation $h_{thresh}$ is chosen, and the first element of any stage trajectory is compared to the threshold. This separates the design matrix into four submatrices, and estimation proceeds following the k-means model. To estimate discharge for a new point, use the difference and threshold to determine which of the four clusters the new trajectory belongs to, choose the corresponding point and calculate discharge with Eq. \ref{k-means-Q}.
